module Update exposing (update)

import Delete.DeleteWords exposing (..)
import Dict exposing (Dict)
import Constants
import FileStorage.Update exposing (updateFileStorageModel)
import FileStorage.Command exposing (loadPropertiesCommand)
import Util.ModifierUtils exposing (hasNumberModifier, getNumberModifier)
import Modes.FileSearch exposing (fileSearchModeUpdate)
import Char
import Util.ListUtils exposing (getLine, mutateAtIndex, removeSlice, insertAtIndex)
import Msg exposing (Msg(..))
import Model exposing (Model, PasteBuffer(..))
import Mode exposing (Mode(..), NavigationType(..))
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
                update (KeyInput <| Constants.getTranslatedArrowKeyFromKeyUp keyPress) model
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

        ReplaceCharacter ->
            let
                middleCharacter =
                    String.cons (Char.fromCode keyPress) ""

                updatedLines =
                    mutateAtIndex model.cursorY
                        model.lines
                        (\line ->
                            (String.left (model.cursorX) line)
                                ++ (middleCharacter)
                                ++ (String.dropLeft (model.cursorX + 1) line)
                        )

                isValidCharacter =
                    Char.isDigit (Char.fromCode keyPress)
                        || Char.isUpper (Char.fromCode keyPress)
                        || Char.isLower (Char.fromCode keyPress)
            in
                if isValidCharacter then
                    { model
                        | lines = updatedLines
                        , mode = Control
                        , lastAction = Keys ("r" ++ middleCharacter)
                    }
                        ! []
                else
                    { model | mode = Control } ! []

        FileSearch _ _ ->
            fileSearchModeUpdate model keyPress

        Command _ ->
            commandModeUpdate model keyPress

        ChangeText ->
            changeTextModeUpdate model keyPress

        ChangeToLine ->
            changeToLineModeUpdate model keyPress

        ChangeToCharacter navigationMode ->
            changeToCharacterModeUpdate model keyPress navigationMode

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


changeModeActionDict : Dict Char (List ActionEntry)
changeModeActionDict =
    Dict.empty
        |> Dict.insert '$' ([ Keys "d$a" ])
        |> Dict.insert '0' ([ Keys "d0i" ])


changeToCharacterModeUpdate : Model -> KeyCode -> NavigationType -> ( Model, Cmd msg )
changeToCharacterModeUpdate model keyPress navigationType =
    let
        ( { cursorX, lines, buffer }, _ ) =
            deleteModeUpdate { model | mode = Delete (NavigateToCharacter navigationType) } keyPress

        modeChar =
            case navigationType of
                Til ->
                    "t"

                To ->
                    "f"

                TilBack ->
                    "T"

                ToBack ->
                    "F"

        newLastAction =
            Keys <|
                (model |> getNumberModifier |> toString)
                    ++ "c"
                    ++ modeChar
                    ++ (String.cons (Char.fromCode keyPress) "")
    in
        if lines /= model.lines then
            { model
                | cursorX = cursorX
                , lines = lines
                , buffer = buffer
                , mode = Insert
                , lastAction = newLastAction
                , numberBuffer = []
            }
                ! []
        else
            { model | mode = Control } ! []


changeTextModeUpdate : Model -> KeyCode -> ( Model, Cmd msg )
changeTextModeUpdate model keyPress =
    case Dict.get (Char.fromCode keyPress) changeModeActionDict of
        Nothing ->
            if keyPress |> Char.fromCode |> Char.isDigit then
                let
                    ( { numberBuffer }, _ ) =
                        updateKeyInput keyPress Control model
                in
                    { model | numberBuffer = numberBuffer } ! []
            else if List.member (Char.fromCode keyPress) [ 't', 'T', 'f', 'F' ] then
                let
                    ( { mode }, _ ) =
                        controlModeUpdate model keyPress
                in
                    case mode of
                        NavigateToCharacter (_ as navigationType) ->
                            { model | mode = ChangeToCharacter navigationType } ! []

                        _ ->
                            model ! []
            else if Char.fromCode keyPress == 'G' then
                handleChangeToEndOfBuffer model ! []
            else
                case Char.fromCode keyPress of
                    'k' ->
                        handleUp model ! []

                    'j' ->
                        handleDown model ! []

                    'l' ->
                        handleRight model ! []

                    'h' ->
                        handleLeft model ! []

                    'g' ->
                        { model | mode = ChangeToLine } ! []

                    'e' ->
                        handleChangeToEndOfWords model ! []

                    'w' ->
                        handleChangeWords model ! []

                    _ ->
                        ( { model | mode = Control }, Cmd.none )

        Just actions ->
            let
                updatedModel =
                    applyActions { model | mode = Control } actions

                newBuffer =
                    if updatedModel.buffer == InlineBuffer [ "" ] then
                        model.buffer
                    else
                        updatedModel.buffer

                modelWithLastAction =
                    { updatedModel
                        | lastAction = Keys <| (toString <| getNumberModifier model) ++ "c" ++ (String.cons (Char.fromCode keyPress) "")
                        , buffer = newBuffer
                        , numberBuffer = []
                    }
            in
                ( modelWithLastAction, Cmd.none )


handleChangeToEndOfBuffer : Model -> Model
handleChangeToEndOfBuffer model =
    let
        ( withoutLastLines, newBuffer ) =
            removeSlice (model.cursorY) (List.length model.lines) model.lines

        updatedLines =
            withoutLastLines ++ [ "" ]
    in
        { model
            | lines = updatedLines
            , mode = Insert
            , lastAction = Keys "cG"
            , buffer = newBuffer
            , cursorX = 0
        }


handleChangeToEndOfWords : Model -> Model
handleChangeToEndOfWords model =
    let
        deletedModel =
            deleteToEndOfWord model

        newLastAction =
            Keys <|
                (toString <| getNumberModifier model)
                    ++ "ce"

        updatedModel =
            { deletedModel
                | mode = Insert
                , numberBuffer = []
                , lastAction = newLastAction
                , cursorX = model.cursorX
            }
    in
        updatedModel


handleChangeWords : Model -> Model
handleChangeWords model =
    handleChangeWordsInner model (getNumberModifier model)


handleChangeWordsInner : Model -> Int -> Model
handleChangeWordsInner model numLeft =
    let
        newLastAction =
            Keys <|
                (toString <| getNumberModifier model)
                    ++ "cw"

        currentLine =
            getLine model.cursorY model.lines

        numberAtEnd =
            currentLine
                |> String.dropLeft model.cursorX
                |> String.trimLeft
                |> String.toList
                |> dropWhile (\char -> char /= ' ')
                |> List.length

        newLine =
            String.left model.cursorX currentLine
                ++ String.right numberAtEnd currentLine

        newLines =
            mutateAtIndex model.cursorY model.lines <| \_ -> newLine

        newBuffer =
            currentLine
                |> String.dropLeft model.cursorX
                |> String.dropRight numberAtEnd
                |> List.singleton
                |> InlineBuffer

        updatedModel =
            { model
                | mode = Insert
                , numberBuffer = []
                , lines = newLines
                , buffer = newBuffer
                , lastAction = newLastAction
            }
    in
        updatedModel


dropWhile : (a -> Bool) -> List a -> List a
dropWhile selector list =
    case list of
        first :: rest ->
            if selector first then
                dropWhile selector rest
            else
                list

        [] ->
            []


handleRight : Model -> Model
handleRight model =
    let
        numberModifier =
            getNumberModifier model

        newLastAction =
            Keys <|
                (toString <| getNumberModifier model)
                    ++ "cl"

        afterDeletion =
            applyActions { model | mode = Control } [ Keys "dl" ]

        afterActions =
            { afterDeletion | mode = Insert, numberBuffer = [], cursorX = model.cursorX }
    in
        { afterActions | lastAction = newLastAction }


handleLeft : Model -> Model
handleLeft model =
    let
        numberModifier =
            getNumberModifier model

        newLastAction =
            Keys <|
                (toString <| getNumberModifier model)
                    ++ "ch"

        afterDeletion =
            applyActions { model | mode = Control } [ Keys "dh" ]

        afterActions =
            { afterDeletion | mode = Insert, numberBuffer = [] }
    in
        { afterActions | lastAction = newLastAction }


handleUp : Model -> Model
handleUp model =
    let
        numberModifier =
            getNumberModifier model
    in
        if model.cursorY - numberModifier - 1 < 0 then
            { model | mode = Control, numberBuffer = [] }
        else
            let
                newLastAction =
                    Keys <|
                        (toString <| getNumberModifier model)
                            ++ "ck"

                afterDeletion =
                    applyActions { model | mode = Control } [ Keys "dk" ]

                afterActions =
                    if afterDeletion.cursorY == List.length afterDeletion.lines - 1 then
                        applyActions { afterDeletion | mode = Control } [ Keys "o" ]
                    else
                        { afterDeletion | mode = Insert }
            in
                { afterActions | lastAction = newLastAction }


handleDown : Model -> Model
handleDown model =
    let
        numberModifier =
            getNumberModifier model
    in
        if model.cursorY + numberModifier + 1 >= List.length model.lines then
            { model | mode = Control, numberBuffer = [] }
        else
            let
                newLastAction =
                    Keys <|
                        (toString <| getNumberModifier model)
                            ++ "cj"

                afterActions =
                    applyActions { model | mode = Control } [ Keys "djO" ]
            in
                { afterActions | lastAction = newLastAction }


changeToLineModeUpdate : Model -> KeyCode -> ( Model, Cmd msg )
changeToLineModeUpdate model keyCode =
    if Char.fromCode keyCode == 'g' then
        let
            targetLine =
                if hasNumberModifier model then
                    getNumberModifier model
                else
                    0

            ( actualLow, actualHigh ) =
                if model.cursorY < targetLine then
                    ( model.cursorY, targetLine )
                else
                    ( targetLine, model.cursorY + 1 )

            ( withoutLastLines, newBuffer ) =
                removeSlice actualLow actualHigh model.lines

            updatedLines =
                insertAtIndex actualLow withoutLastLines ""

            actualBuffer =
                if newBuffer == LinesBuffer [] then
                    LinesBuffer [ "" ]
                else
                    newBuffer
        in
            { model
                | lines = updatedLines
                , mode = Insert
                , lastAction = Keys "cgg"
                , buffer = actualBuffer
                , cursorX = 0
                , cursorY = actualLow
            }
                ! []
    else
        { model | mode = Control } ! []
