module NavigateToLineTests exposing (..)

import Expect
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List
import Mode exposing (Mode(..))
import Model exposing (Model, PasteBuffer(..))


testNavigateToFile : Test
testNavigateToFile =
    describe "number with G" <|
        [ let
            { numberBuffer, mode, lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i", Enter, Enter, Escape, Keys "kk1GG" ]
          in
            describe "kk1GG"
                [ test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 2
                ]
        ]
