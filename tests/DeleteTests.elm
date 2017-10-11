module DeleteTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List exposing (..)
import Model exposing (PasteBuffer(..))
import Util.ListUtils exposing (..)


deleteToEndOfLineWithDollarTests : Test
deleteToEndOfLineWithDollarTests =
    describe "Testing d$"
        [ test "d$ deletes the contents after the cursor" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "iaaaaabbbbbccccc", Escape, Keys "hhhhhhhd$" ]
                in
                    Expect.equal lines [ "aaaaabb" ]
        , test "d$ copies the text it deletes" <|
            \_ ->
                let
                    { buffer } =
                        newStateAfterActions [ Keys "iaaaaabbbbbccccc", Escape, Keys "hhhhhhhd$" ]
                in
                    Expect.equal buffer (InlineBuffer [ "bbbccccc" ])
        ]


deleteWordsTests : Test
deleteWordsTests =
    describe "Testing dw"
        [ test "dw deletes one word" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "ione two three four", Escape, Keys "0dw" ]
                in
                    Expect.equal lines [ "two three four" ]
        , test "dw copies the deleted word" <|
            \_ ->
                let
                    { buffer } =
                        newStateAfterActions [ Keys "ione two three four", Escape, Keys "0dw" ]
                in
                    Expect.equal buffer <| InlineBuffer [ "one " ]
        , test "dw leaves the cursor where it was" <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions [ Keys "ione two three four", Escape, Keys "0dw" ]
                in
                    Expect.equal cursorX 0
        , test "3dw deletes 3 words" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "ione two three four", Escape, Keys "03dw" ]
                in
                    Expect.equal lines [ "four" ]
        , test "3dw copies the deleted words" <|
            \_ ->
                let
                    { buffer } =
                        newStateAfterActions [ Keys "ione two three four", Escape, Keys "03dw" ]
                in
                    Expect.equal buffer <| InlineBuffer [ "one two three " ]
        , test "3dw clears inProgress" <|
            \_ ->
                let
                    { inProgress } =
                        newStateAfterActions [ Keys "ione two three four", Escape, Keys "03dw" ]
                in
                    Expect.equal inProgress []
        , test "3dw leaves the cursor where it was" <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions [ Keys "ione two three four", Escape, Keys "03dw" ]
                in
                    Expect.equal cursorX 0
        , test "5dw leaves cursorX where it was over multiple lines" <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions [ Keys "ione two three", Enter, Keys "four five six", Escape, Keys "0k4dw" ]
                in
                    Expect.equal cursorX 0
        , test "5dw deletes words over multiple lines" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "ione two three", Enter, Keys "four five six", Escape, Keys "0k4dw" ]
                in
                    Expect.equal lines [ "five six" ]
        , test "5dw copies words into the buffer" <|
            \_ ->
                let
                    { buffer } =
                        newStateAfterActions [ Keys "ione two three", Enter, Keys "four five six", Escape, Keys "0k4dw" ]
                in
                    Expect.equal buffer <| InlineBuffer [ "one two three", "four " ]
        , test "only delete to the next word boundary" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "i one two three", Escape, Keys "0dw" ]
                in
                    Expect.equal lines [ "one two three" ]
        , test "do copy when there's only whitespace" <|
            \_ ->
                let
                    { buffer } =
                        newStateAfterActions [ Keys "i one two three", Escape, Keys "0dw" ]
                in
                    Expect.equal buffer <| InlineBuffer [ " " ]
        , test "over multiple empty lines, dw only takes one line" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "i", Enter, Enter, Enter, Escape, Keys "ggdw" ]
                in
                    Expect.equal lines [ "", "", "" ]
        , test "multiple dw is the same as dd over empty lines" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "i", Enter, Enter, Enter, Escape, Keys "gg2dw" ]
                in
                    Expect.equal lines [ "", "" ]
        ]


deleteToEndOfLineWithCapitalDTests : Test
deleteToEndOfLineWithCapitalDTests =
    describe "Testing D"
        [ test "D deletes the contents after the cursor" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "iaaaaabbbbbccccc", Escape, Keys "hhhhhhhD" ]
                in
                    Expect.equal lines [ "aaaaabb" ]
        , test "D copies the text it deletes" <|
            \_ ->
                let
                    { buffer } =
                        newStateAfterActions [ Keys "iaaaaabbbbbccccc", Escape, Keys "hhhhhhhD" ]
                in
                    Expect.equal buffer (InlineBuffer [ "bbbccccc" ])
        ]


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
        , test "after deleting past the end of the buffer, cursorY pops up by one" <|
            \_ ->
                let
                    { cursorY } =
                        newStateAfterActions [ Keys "i", Enter, Enter, Escape, Keys "k200dd" ]
                in
                    Expect.equal cursorY 0
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
