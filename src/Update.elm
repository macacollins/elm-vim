module Update exposing (update)

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
import Import.AcceptBuffer exposing (acceptBuffer)
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

        AcceptBuffer buffer ->
            acceptBuffer model buffer
                |> updateLinesShown

        Paste pasteString ->
            paste model pasteString |> updateLinesShown

        KeyUp keyPress ->
            if List.member keyPress [ 27, 8, 9 ] then
                update (KeyInput keyPress) model
            else if List.member keyPress [ 37, 38, 39, 40 ] then
                translateArrowKeys keyPress
                    |> controlModeUpdate model
                    |> updateLinesShown
            else
                ( model, Cmd.none )

        WindowResized size ->
            let
                newWidth =
                    Debug.log "newHeight" ((toFloat size.width) / 9.5 |> floor)

                newHeight =
                    Debug.log "newHeight" (size.height // 19) - 1

                newLinesShown =
                    getNumberOfLinesOnScreen partiallyUpdatedModel
                        |> Debug.log "newLinesShown"

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
        Insert ->
            insertModeUpdate model keyPress

        Control ->
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

        Command _ ->
            commandModeUpdate model keyPress

        Macro inner ->
            let
                -- future bug if we start returning cmds
                -- this could impact performance if we are calculating a model we won't use
                ( newModel, _ ) =
                    updateKeyInput keyPress inner { model | mode = inner }

                initialModel =
                    model
            in
                -- consider re-ordering this
                macroRecordModeUpdate newModel initialModel keyPress


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

                Macro Control ->
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
