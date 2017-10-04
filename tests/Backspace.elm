module Backspace exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List exposing (..)
import Util.ListUtils exposing (..)


capitalXTests : Test
capitalXTests =
    describe "The X key"
        [ test "Remove the previous character" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "iabc", Escape, Keys "X" ]
                in
                    Expect.equal lines [ "ac" ]
        , test "Move cursorX back by one" <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions [ Keys "ia", Escape, Keys "X" ]
                in
                    Expect.equal cursorX 0
        , test "Don't move cursorX below 0" <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions [ Keys "X" ]
                in
                    Expect.equal cursorX 0
        ]
