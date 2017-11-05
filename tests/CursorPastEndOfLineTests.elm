module CursorPastEndOfLineTests exposing (..)

import Expect
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List
import Mode exposing (Mode(..))
import Model exposing (Model, PasteBuffer(..))


testCursorPastEndOfLine : Test
testCursorPastEndOfLine =
    describe "cursor past end of line" <|
        [ let
            { mode, lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "ilongstring", Enter, Keys "second", Escape, Keys "k$jx" ]
          in
            describe "x"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "longstring", "secon" ]
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "d" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 4
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 1
                ]
        ]
