module ScreenMovementTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List


testH : Test
testH =
    describe "Testing H key"
        [ test "takes cursorY to the top of the screen" <|
            \_ ->
                let
                    { cursorY } =
                        newStateAfterActions <|
                            [ Keys "i" ]
                                ++ (List.repeat 35 Enter)
                                ++ [ Escape, Keys "H" ]
                in
                    Expect.equal cursorY 5
        ]


testM : Test
testM =
    describe "Testing M"
        [ test "M takes you half the lines down." <|
            \_ ->
                let
                    { cursorY } =
                        newStateAfterActions <| [ Keys "i" ] ++ (List.repeat 29 Enter) ++ [ Escape, Keys "M" ]
                in
                    Expect.equal cursorY 15
        , test "M doesn't take you past the end of the buffer." <|
            \_ ->
                let
                    { cursorY } =
                        newStateAfterActions <| [ Keys "i" ] ++ (List.repeat 4 Enter) ++ [ Escape, Keys "M" ]
                in
                    Expect.equal cursorY 4
        ]
