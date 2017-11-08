module Modes.MacroRecord exposing (macroRecordModeUpdate)

import Model exposing (..)
import Keyboard exposing (KeyCode)
import Char
import Mode exposing (Mode(..))
import Dict exposing (Dict)
import History exposing (addHistory)
import Util.Search exposing (searchTo)
import Macro.Model exposing (MacroModel)
import Macro.ActionEntry exposing (ActionEntry(..))
import Macro.KeysToActionEntries exposing (keysToActionEntries)


macroRecordModeUpdate : Model -> Model -> Char -> KeyCode -> ( Model, Cmd msg )
macroRecordModeUpdate model initialModel bufferCharacter keyCode =
    let
        shouldExit =
            case initialModel.mode of
                Macro _ Control ->
                    Char.fromCode keyCode == 'q'

                _ ->
                    False

        newMode =
            Macro bufferCharacter model.mode

        updatedMacroModel =
            addToBuffer keyCode model.macroModel
    in
        if shouldExit then
            flushBuffer model bufferCharacter ! []
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


getSuite : Model -> String
getSuite model =
    let
        { macroMap } =
            model.macroModel

        allMacros =
            Dict.values macroMap

        testStrings =
            allMacros
                |> List.map getTest
                |> String.join "\n    , "
    in
        start ++ testStrings ++ end


start : String
start =
    """
zTests : Test
zTests =
  describe "z" <|
    [ """


end : String
end =
    "\n    ]"


getTest : List ActionEntry -> String
getTest macro =
    let
        macroName =
            case List.head (List.reverse macro) of
                Just head ->
                    case head of
                        Keys actualKeys ->
                            actualKeys

                        _ as other ->
                            toString other

                _ ->
                    "Empty test."
    in
        """
      let
          { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
            newStateAfterActions """
            ++ (toString macro)
            ++ """
        in
          describe """
            ++ toString macroName
            ++ """
            [ test "lines" <|
              \\_ ->
                Expect.equal lines [ "" ]
            , test "numberBuffer" <|
              \\_ ->
                Expect.equal numberBuffer []
            , test "lastAction" <|
              \\_ ->
                Expect.equal lastAction <| Keys ""
            , test "buffer" <|
              \\_ ->
                Expect.equal buffer <| LinesBuffer []
            , test "cursorX" <|
              \\_ ->
                Expect.equal cursorX 0
            , test "cursorY" <|
              \\_ ->
                Expect.equal cursorY 0
            , test "mode" <|
              \\_ ->
                Expect.equal mode Control
            ]"""


flushBuffer : Model -> Char -> Model
flushBuffer model char =
    let
        { macroModel, properties } =
            model

        trash2 =
            if properties.testsFromMacros then
                Debug.log
                    (getSuite finalModel)
                    0
            else
                1

        updatedMacroMap : Dict Char (List ActionEntry)
        updatedMacroMap =
            Dict.insert
                char
                macroModel.buffer
                macroModel.macroMap

        updatedMacroModel =
            { macroModel
                | buffer = []
                , rawBuffer = []
                , macroMap = updatedMacroMap
            }

        finalModel =
            { model | mode = Control, macroModel = updatedMacroModel }
    in
        finalModel
