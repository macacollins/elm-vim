module JoinTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List exposing (..)
import Util.ListUtils exposing (..)


capitalJTests : Test
capitalJTests =
    describe "The J"
        [ test "Join 2 lines" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "ia", Enter, Keys "b", Escape, Keys "ggJ" ]

                    line =
                        getLine 0 lines
                in
                    Expect.equal line "a b"
        , test "ignore command if on last line" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "ia", Enter, Keys "b", Escape, Keys "J" ]

                    line =
                        getLine 0 lines
                in
                    Expect.equal line "a"
        , test "truncate spaces" <|
            \_ ->
                let
                    lotsOfSpace =
                        "                         b"

                    { lines } =
                        newStateAfterActions [ Keys "ia", Enter, Keys lotsOfSpace, Escape, Keys "ggJ" ]

                    line =
                        getLine 0 lines
                in
                    Expect.equal line "a b"
        ]
