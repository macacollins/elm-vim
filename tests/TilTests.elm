module TilTests exposing (..)

import Expect
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List


navigateUsingT : Test
navigateUsingT =
    describe "z" <|
        [ let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i12345", Escape, Keys "t5" ]
          in
            describe "t5 when already at 5"
                [ test "changes lines" <|
                    \_ ->
                        Expect.equal lines [ "12345" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 4
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i123123", Escape, Keys "0t3t3t3t3t3t3t3" ]
          in
            describe "many t3s"
                [ test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 1
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i123123", Escape, Keys "0t3" ]
          in
            describe "to 3 when there are multiple 3s"
                [ test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 1
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i12345", Escape, Keys "0t5" ]
          in
            describe "go to 5 from start of line"
                [ test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 3
                ]
        ]
