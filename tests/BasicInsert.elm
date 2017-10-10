module BasicInsert exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List
import Util.ListUtils exposing (..)


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
