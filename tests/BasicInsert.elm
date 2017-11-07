module BasicInsert exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List
import Util.ListUtils exposing (..)


enterSplitsLineTests : Test
enterSplitsLineTests =
    describe "Enter" <|
        [ let
            { mode, lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "hhhi", Enter, Escape ]
          in
            describe "Enter splits lines"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "1234", "1234" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 1
                ]
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
