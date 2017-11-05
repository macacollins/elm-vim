module CommandTests exposing (..)

import Expect
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List
import Mode exposing (Mode(..))
import Model exposing (Model, PasteBuffer(..))
import Message exposing (Message(..))


testErrorMessages : Test
testErrorMessages =
    describe "error messages" <|
        [ let
            { mode, lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys ":tesaestawe", Enter ]
          in
            describe "Enter"
                [ test "mode" <|
                    \_ ->
                        Expect.equal mode <| ShowMessage (UnrecognizedCommand "tesaestawe") Control
                ]
        ]
