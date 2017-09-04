module BasicInsert exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Actions exposing (ActionEntry(..), newStateAfterActions)
import Array


canary : Test
canary =
    describe "The test suite"
        [ test "Is it running?" <|
            \_ -> Expect.equal 1 1
        ]


testBasicInsert : Test
testBasicInsert =
    describe "Basic Inserts"
        [ test "Insert a" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions
                            [ Keys "iA" ]

                    firstLine =
                        case Array.get 0 lines of
                            Just line ->
                                line

                            Nothing ->
                                "No string found!"
                in
                    Expect.equal firstLine "A"
        ]
