module BasicInsert exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Actions exposing (ActionEntry(..), newStateAfterActions)
import List
import Util.ListUtils exposing (..)


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
                        getLine 0 lines
                in
                    Expect.equal firstLine "A"
        , test "Enter Key" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions
                            [ Keys "i", Enter, Enter ]
                in
                    Expect.equal 3 (List.length lines)
        , test "Enter Key Does nothing in control mode" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions
                            [ Enter, Enter ]
                in
                    Expect.equal 1 (List.length lines)
        , test "Enter Key Does nothing in control mode 2" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions
                            [ Keys "i", Enter, Escape, Enter ]
                in
                    Expect.equal 2 (List.length lines)
        ]
