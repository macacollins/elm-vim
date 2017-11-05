module Update exposing (update)

import FileStorage.Update exposing (updateFileStorageModel)
import FileStorage.Command exposing (loadPropertiesCommand)
import Modes.FileSearch exposing (fileSearchModeUpdate)
import Char
import Msg exposing (Msg(..))
import Model exposing (Model)
import Mode exposing (Mode(..))
import Modes.Control exposing (controlModeUpdate)
import Modes.Command exposing (commandModeUpdate)
import Modes.Visual exposing (visualModeUpdate)
import Modes.NavigateToCharacter exposing (navigateToCharacterModeUpdate)
import Modes.Insert exposing (insertModeUpdate)
import Modes.Yank exposing (yankModeUpdate)
import Modes.Delete exposing (deleteModeUpdate)
import Modes.Search exposing (searchModeUpdate)
import Modes.MacroRecord exposing (macroRecordModeUpdate)
import Control.NavigateFile exposing (goToLineModeUpdate)
import Keyboard exposing (KeyCode)
import Window
import Macro.ActionEntry exposing (ActionEntry(..))
import Macro.Model exposing (getMacro)
import View.Util exposing (getActualScreenWidth, getNumberOfLinesOnScreen)


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        KeyInput keyPress ->
            updateKeyInput keyPress model.mode model
                |> updateLinesShown

        HandleFileStorageMessage value ->
            updateFileStorageModel model value

        Paste pasteString ->
            paste model pasteString |> updateLinesShown

        KeyUp keyPress ->
            if List.member keyPress [ 27, 8, 9 ] then
                update (KeyInput keyPress) model
            else if List.member keyPress [ 37, 38, 39, 40 ] then
                update (KeyInput (keyPress - 41)) model
            else
                ( model, Cmd.none )

        WindowResized size ->
            let
                newWidth =
                    ((toFloat size.width) / 9.5 |> floor) - 1

                newHeight =
                    (size.height // 19) - 1

                newLinesShown =
                    getNumberOfLinesOnScreen partiallyUpdatedModel

                partiallyUpdatedModel =
                    { model
                        | windowHeight = newHeight
                        , windowWidth = newWidth
                    }
            in
                { model
                    | windowHeight = newHeight
                    , windowWidth = newWidth
                    , linesShown = newLinesShown
                }
                    ! []


updateLinesShown : ( Model, Cmd msg ) -> ( Model, Cmd msg )
updateLinesShown ( model, command ) =
    ( { model | linesShown = getNumberOfLinesOnScreen model }, command )


updateKeyInput : KeyCode -> Mode -> Model -> ( Model, Cmd msg )
updateKeyInput keyPress mode model =
    case mode of
        StartingMessage ->
            {-
               TODO update this to leave this mode when vim does
               This will probably involve:
               1. lines change
               2. command done run

               At the time of writing, I don't know how to detect that a command has run
               without storing additional state or adding an extra mode like
               StartingMessageCommandStarted
            -}
            updateKeyInput keyPress Control { model | mode = Control }

        ShowMessage _ innerMode ->
            updateKeyInput keyPress innerMode { model | mode = innerMode }

        Insert ->
            insertModeUpdate model keyPress

        Control ->
            -- TODO figure out a different structure that avoids loops
            -- Pass in update as a function parameter? It's not special
            if Char.fromCode keyPress == '.' then
                applyActions model [ model.lastAction ] ! []
            else
                controlModeUpdate model keyPress

        GoToLine ->
            goToLineModeUpdate model

        Yank _ ->
            yankModeUpdate model keyPress

        NavigateToCharacter _ ->
            navigateToCharacterModeUpdate model keyPress

        Delete _ ->
            deleteModeUpdate model keyPress

        Search ->
            searchModeUpdate model keyPress

        MacroExecute ->
            -- not sure how to do this in multiple files without introducing a circular reference :D
            macroExecuteModeUpdate model keyPress

        Visual _ _ ->
            visualModeUpdate model keyPress

        FileSearch _ _ ->
            fileSearchModeUpdate model keyPress

        Command _ ->
            commandModeUpdate model keyPress

        EnterMacroName ->
            let
                char =
                    Char.fromCode keyPress

                isAsciiOrNumber =
                    Char.isUpper char || Char.isLower char || Char.isDigit char
            in
                if isAsciiOrNumber then
                    { model | mode = Macro char Control } ! []
                else
                    { model | mode = Control }
                        ! [ loadPropertiesCommand ]

        Macro bufferChar inner ->
            let
                -- future bug if we start returning cmds
                -- this could impact performance if we are calculating a model we won't use
                ( newModel, _ ) =
                    updateKeyInput keyPress inner { model | mode = inner }

                initialModel =
                    model
            in
                -- consider re-ordering this
                macroRecordModeUpdate newModel initialModel bufferChar keyPress


translateArrowKeys input =
    if input == 37 then
        104
    else if input == 38 then
        107
    else if input == 39 then
        108
    else if input == 40 then
        106
    else
        0


macroExecuteModeUpdate : Model -> KeyCode -> ( Model, Cmd msg )
macroExecuteModeUpdate model keyPress =
    let
        targetMacro =
            getMacro
                (Char.fromCode keyPress)
                model.macroModel
    in
        applyActions { model | mode = Control } targetMacro ! []



-- WARNING!!! The below is copy / pasted from Actions. need to fix it up


applyActions : Model -> List ActionEntry -> Model
applyActions model actions =
    List.foldl enterKeySequence model actions


enterKeySequence : ActionEntry -> Model -> Model
enterKeySequence actionEntry model =
    let
        codes =
            getCodeList actionEntry

        applyKey : KeyCode -> Model -> Model
        applyKey code model =
            let
                ( newModel, _ ) =
                    update (KeyInput code) model
            in
                newModel
    in
        List.foldr applyKey model codes


getCodeList : ActionEntry -> List KeyCode
getCodeList actionEntry =
    case actionEntry of
        Enter ->
            [ 13 ]

        Escape ->
            [ 27 ]

        Backspace ->
            [ 8 ]

        Keys keys ->
            let
                addCodeAndRecur : Char -> List KeyCode -> List KeyCode
                addCodeAndRecur character resultList =
                    Char.toCode character :: resultList
            in
                String.foldl addCodeAndRecur [] keys


paste : Model -> String -> ( Model, Cmd msg )
paste model string =
    let
        withOptionalI : String
        withOptionalI =
            case model.mode of
                Control ->
                    String.cons 'i' string

                Macro _ Control ->
                    String.cons 'i' string

                _ ->
                    string

        updatedModel =
            getActionsFromString withOptionalI
                |> applyActions model
    in
        updatedModel ! []


getActionsFromString : String -> List ActionEntry
getActionsFromString string =
    string
        |> String.split (String.cons (Char.fromCode 10) "")
        |> List.concatMap (String.split (String.cons (Char.fromCode 13) ""))
        |> List.map Keys
        |> List.intersperse Enter
