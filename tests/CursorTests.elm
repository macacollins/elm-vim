module CursorTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Actions exposing (ActionEntry(..), newStateAfterActions)
import Array


testCursor : Test
testCursor =
    describe "Basic Cursor Movement"
        [ test "Increments on input" <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions
                            [ Keys "iaaa" ]
                in
                    Expect.equal cursorX 3
        , test "Resets on Enter key" <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions
                            [ Keys "iaaa", Enter ]
                in
                    Expect.equal cursorX 0
        ]
