module DeleteTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List exposing (..)
import Model exposing (PasteBuffer(..))
import Util.ListUtils exposing (..)


dTests : Test
dTests =
    describe "The d key"
        [ test "one key press goes to the in progress" <|
            \_ ->
                let
                    { inProgress } =
                        newStateAfterActions [ Keys "d" ]
                in
                    Expect.equal inProgress [ 'd' ]
        , test "2 key presses removes a line" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "ia", Enter, Keys "test", Escape, Keys "kdd" ]
                in
                    Expect.equal (List.length lines) 1
        , test "2 key presses removes the right line" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "ia", Enter, Keys "test", Escape, Keys "kdd" ]
                in
                    Expect.equal (getLine 0 lines) "test"
        , test "dd puts the line in the paste buffer." <|
            \_ ->
                let
                    { buffer } =
                        newStateAfterActions [ Keys "ia", Escape, Keys "dd" ]
                in
                    Expect.equal buffer <| LinesBuffer [ "a" ]
        , test "2 key presses doesn't remove the last line" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "dd" ]
                in
                    Expect.equal (List.length lines) 1
        ]



-- this would be a good opportunity to use fuzzing


dKeyWithModifiersTests : Test
dKeyWithModifiersTests =
    describe "3 lines at a time"
        [ test "Delete 3 lines." <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "i", Enter, Enter, Enter, Enter, Escape, Keys "gg3dd" ]
                in
                    Expect.equal (List.length lines) 2
        , test "Delete too many lines." <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "i", Enter, Enter, Enter, Enter, Escape, Keys "gg30dd" ]
                in
                    Expect.equal (List.length lines) 1
        , test "Modifiers go in properly" <|
            \_ ->
                let
                    { inProgress } =
                        newStateAfterActions [ Keys "1234567890" ]
                in
                    Expect.equal (List.length inProgress) 10
        ]


backspaceTests : Test
backspaceTests =
    describe "backspacin'"
        [ test "delete one character" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "ia", Backspace ]
                in
                    Expect.equal (getLine 0 lines) ""
        , test "after one delete, " <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions [ Keys "ia", Backspace ]
                in
                    Expect.equal cursorX 0
        , test "more characters, " <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions [ Keys "iaaaaaa", Backspace, Backspace, Backspace, Backspace, Backspace, Backspace ]
                in
                    Expect.equal cursorX 0
        , test "more characters actually deletes all the characters " <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "iaaaaaa", Backspace, Backspace, Backspace, Backspace, Backspace, Backspace ]
                in
                    Expect.equal (getLine 0 lines) ""
        , test "copies line onto previous line when at 0 cursorX" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "ia", Enter, Keys "a", Escape, Keys "hi", Backspace ]
                in
                    Expect.equal (getLine 0 lines) "aa"
        , test "remove line if at 0 index" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "i", Enter, Backspace ]
                in
                    Expect.equal (List.length lines) 1
        , test "Moves the cursor up one if a line got removed." <|
            \_ ->
                let
                    { cursorY } =
                        newStateAfterActions [ Keys "i", Enter, Backspace ]
                in
                    Expect.equal cursorY 0
        , test "Moves the cursor to the right horizontal position." <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions [ Keys "iaa", Enter, Keys "a", Escape, Keys "hi", Backspace ]
                in
                    Expect.equal cursorX 2
        , test "Doesn't remove the first line." <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "ia", Escape, Keys "hi", Backspace ]
                in
                    Expect.equal (getLine 0 lines) "a"
        ]


getLine : Int -> List String -> String
getLine index lines =
    case head <| drop index lines of
        Just item ->
            item

        Nothing ->
            "Failed; no lines"


xTests : Test
xTests =
    describe "The x key"
        [ test "Delete one character" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "iaa", Escape, Keys "hx" ]

                    finalLine =
                        getLine 0 lines
                in
                    Expect.equal finalLine "a"
        , test "Doesn't switch lines" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "iaa", Enter, Escape, Keys "khx" ]

                    finalLine =
                        getLine 0 lines
                in
                    Expect.equal finalLine "a"
        ]
