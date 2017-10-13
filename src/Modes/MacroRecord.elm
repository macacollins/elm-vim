module Modes.MacroRecord exposing (macroRecordModeUpdate)

import Model exposing (..)
import Keyboard exposing (KeyCode)
import Char
import Mode exposing (Mode(..))
import Dict
import History exposing (addHistory)
import Util.Search exposing (searchTo)
import Macro.Model exposing (MacroModel)
import Macro.ActionEntry exposing (ActionEntry(..))
import Macro.KeysToActionEntries exposing (keysToActionEntries)


-- TODO probably refactor


macroRecordModeUpdate : Model -> Model -> KeyCode -> ( Model, Cmd msg )
macroRecordModeUpdate model initialModel keyCode =
    let
        { macroModel } =
            model

        charVersion =
            Char.fromCode keyCode

        -- still not sure this is the right spot
        shouldExit =
            (initialModel.mode == Macro Control)
                && (macroModel.bufferChar /= Nothing)
                && (Char.fromCode keyCode == 'q')

        updatedMacroModel =
            case macroModel.bufferChar of
                Just char ->
                    addToBuffer keyCode macroModel

                Nothing ->
                    if Char.isDigit charVersion || Char.isLower charVersion || Char.isUpper charVersion then
                        { macroModel | bufferChar = Just charVersion }
                    else
                        macroModel

        newMode =
            -- if the model passed in didn't update from macro, don't add another macro
            -- but if it returned a non-macro type, wrap with macro
            case model.mode of
                Macro inner ->
                    Macro inner

                _ as other ->
                    Macro other
    in
        if shouldExit then
            -- TODO flush buffer to dict
            flushBuffer model ! []
        else if macroModel.bufferChar == Nothing then
            { initialModel | macroModel = updatedMacroModel } ! []
        else
            { model | macroModel = updatedMacroModel, mode = newMode } ! []



-- tricky part is condensing to single Key parts.
-- Should consider getting the whole sequence and condensing after


addToBuffer : KeyCode -> MacroModel -> MacroModel
addToBuffer keyCode macroModel =
    let
        newRawBuffer =
            macroModel.rawBuffer ++ [ keyCode ]

        newBuffer =
            keysToActionEntries newRawBuffer
    in
        { macroModel | buffer = newBuffer, rawBuffer = newRawBuffer }


flushBuffer : Model -> Model
flushBuffer model =
    let
        { macroModel } =
            model

        trash2 =
            Debug.log
                ("""
        , describe "additional test" <|
            let
                { lines, cursorX, buffer, cursorY } =
                    newStateAfterActions """
                    ++ (toString macroModel.buffer)
                    ++ """
            in
                [ test "changes lines" <|
                    \\_ ->
                        Expect.equal lines [ "" ]
                , test "copies into buffer" <|
                    \\_ ->
                        Expect.equal buffer <| LinesBuffer [ "one two", "three four" ]
                , test "moves cursorX" <|
                    \\_ ->
                        Expect.equal cursorX 0
                , test "moves cursorY" <|
                    \\_ ->
                        Expect.equal cursorY 0
                ]
            """
                )
                0

        trash =
            Debug.log
                ("""
zTests : Test
zTests =
    describe "deleting down"
        [ describe "single dj" <|
            let
                { lines, cursorX, buffer, cursorY } =
                    newStateAfterActions """
                    ++ (toString macroModel.buffer)
                    ++ """
            in
                [ test "dj deletes two lines" <|
                    \\_ ->
                        Expect.equal lines [ "" ]
                , test "dj copies the deleted word" <|
                    \\_ ->
                        Expect.equal buffer <| LinesBuffer [ "one two", "three four" ]
                , test "dj moves cursorX back when deleting 2 lines" <|
                    \\_ ->
                        Expect.equal cursorX 0
                , test "dj moves cursorY back when deleting 2 lines" <|
                    \\_ ->
                        Expect.equal cursorY 0
                ]

          ]
            """
                )
                0

        updatedMacroMap =
            case macroModel.bufferChar of
                Just char ->
                    Dict.insert
                        char
                        macroModel.buffer
                        macroModel.macroMap

                Nothing ->
                    macroModel.macroMap

        updatedMacroModel =
            { macroModel
                | bufferChar = Nothing
                , buffer = []
                , rawBuffer = []
                , macroMap = updatedMacroMap
            }
    in
        { model | mode = Control, macroModel = updatedMacroModel }
