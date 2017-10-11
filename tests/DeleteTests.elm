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


deleteUpTests : Test
deleteUpTests =
    describe "deleting up"
        [ describe "single dk" <|
            let
                { lines, cursorX, buffer, cursorY } =
                    newStateAfterActions [ Keys "ione two", Enter, Keys "three four", Escape, Keys "bdk" ]
            in
                [ test "dk deletes one word" <|
                    \_ ->
                        Expect.equal lines [ "" ]
                , test "dk copies the deleted word" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "one two", "three four" ]
                , test "dk moves cursorX back when deleting 2 lines" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "dk moves cursorY back when deleting 2 lines" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , describe "3dk" <|
            let
                { lines, cursorX, buffer, cursorY } =
                    newStateAfterActions
                        [ Keys "ione"
                        , Enter
                        , Keys "two"
                        , Enter
                        , Keys "three"
                        , Enter
                        , Keys "four"
                        , Enter
                        , Keys "five"
                        , Enter
                        , Keys "six"
                        , Escape
                        , Keys "b3dk"
                        ]
            in
                [ test "3dk deletes 4 lines" <|
                    \_ ->
                        Expect.equal lines [ "one", "two" ]
                , test "3dk copies the deleted word" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "three", "four", "five", "six" ]
                , test "3dk moves cursorX back when deleting 4 lines" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "3dk moves cursorY back when deleting 4 lines at the end" <|
                    \_ ->
                        Expect.equal cursorY 1
                ]
        , describe "3dk in middle" <|
            let
                { lines, cursorX, buffer, cursorY } =
                    newStateAfterActions
                        [ Keys "ione"
                        , Enter
                        , Keys "two"
                        , Enter
                        , Keys "three"
                        , Enter
                        , Keys "four"
                        , Enter
                        , Keys "five"
                        , Enter
                        , Keys "six"
                        , Escape
                        , Keys "k3dk"
                        ]
            in
                [ test "3dk deletes 4 lines" <|
                    \_ ->
                        Expect.equal lines [ "one", "six" ]
                , test "3dk copies the deleted word" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "two", "three", "four", "five" ]
                , test "3dk moves cursorX back when deleting 4 lines" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "3dk moves cursorY back to where it would be with 3k if not at the end." <|
                    \_ ->
                        Expect.equal cursorY 1
                ]
        ]


deleteDownTests : Test
deleteDownTests =
    describe "deleting down"
        [ describe "single dj" <|
            let
                { lines, cursorX, buffer, cursorY } =
                    newStateAfterActions [ Keys "ione two", Enter, Keys "three four", Escape, Keys "kdj" ]
            in
                [ test "dj deletes two lines" <|
                    \_ ->
                        Expect.equal lines [ "" ]
                , test "dj copies the deleted word" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "one two", "three four" ]
                , test "dj moves cursorX back when deleting 2 lines" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "dj moves cursorY back when deleting 2 lines" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , describe "3dj" <|
            let
                { lines, cursorX, buffer, cursorY } =
                    newStateAfterActions
                        [ Keys "ione"
                        , Enter
                        , Keys "two"
                        , Enter
                        , Keys "three"
                        , Enter
                        , Keys "four"
                        , Enter
                        , Keys "five"
                        , Enter
                        , Keys "six"
                        , Escape
                        , Keys "ggj3dj"
                        ]
            in
                [ test "3dj deletes one word" <|
                    \_ ->
                        Expect.equal lines [ "one", "six" ]
                , test "3dj copies the deleted word" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "two", "three", "four", "five" ]
                , test "3dj moves cursorX back when deleting 2 lines" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "3dj moves cursorY back when deleting 2 lines" <|
                    \_ ->
                        Expect.equal cursorY 1
                ]
        ]


deleteWordsBackwardsTests : Test
deleteWordsBackwardsTests =
    describe "Testing db"
        [ describe "single db" <|
            let
                { lines, cursorX, buffer } =
                    newStateAfterActions [ Keys "ione two three four", Escape, Keys "db" ]
            in
                [ test "db deletes one word" <|
                    \_ ->
                        Expect.equal lines [ "one two three r" ]
                , test "db copies the deleted word" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "fou" ]
                , test "db moves cursorX back when deleting one word" <|
                    \_ ->
                        Expect.equal cursorX 14
                ]
        , describe "3db" <|
            let
                testModel =
                    newStateAfterActions [ Keys "ione two three four", Escape, Keys "3db" ]
            in
                [ test "3db deletes 3 words" <|
                    \_ ->
                        Expect.equal testModel.lines [ "one r" ]
                , test "3db copies the deleted words" <|
                    \_ ->
                        Expect.equal testModel.buffer <| InlineBuffer [ "two three fou" ]
                , test "3db clears inProgress" <|
                    \_ ->
                        Expect.equal testModel.inProgress []
                , test "3db moves the cursor back too" <|
                    \_ ->
                        Expect.equal testModel.cursorX 4
                ]
        , describe "4db" <|
            let
                { cursorX, lines, buffer, cursorY } =
                    newStateAfterActions [ Keys "ione two three", Enter, Keys "four five six", Escape, Keys "4db" ]
            in
                [ test "4db leaves cursorX where it was over multiple lines" <|
                    \_ ->
                        Expect.equal cursorX 8
                , test "4db deletes words over multiple lines" <|
                    \_ ->
                        Expect.equal lines [ "one two x" ]
                , test "4db copies words into the buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "three", "four five si" ]
                , test "4db changes cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , describe "deleting from whitespace" <|
            let
                { cursorX, lines, buffer, cursorY } =
                    newStateAfterActions [ Keys "ione two three   ", Escape, Keys "db" ]
            in
                [ test "cursorX goes back." <|
                    \_ ->
                        Expect.equal cursorX 8
                , test "cursorY stays the same" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "db removes the last word entirely if fired from inside whitespace" <|
                    \_ ->
                        Expect.equal lines [ "one two  " ]
                , test "db copies the last word into buffer properly" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "three  " ]
                ]
        ]


deleteWordsTests : Test
deleteWordsTests =
    describe "Testing dw"
        [ describe "hello" <|
            let
                { lines, buffer, cursorX } =
                    newStateAfterActions [ Keys "ione two three four", Escape, Keys "0dw" ]
            in
                [ test "dw deletes one word" <|
                    \_ ->
                        Expect.equal lines [ "two three four" ]
                , test "dw copies the deleted word" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "one " ]
                , test "dw leaves the cursor where it was" <|
                    \_ ->
                        Expect.equal cursorX 0
                ]
        , describe "5dw over multiple lines" <|
            let
                { buffer, lines, cursorX } =
                    newStateAfterActions [ Keys "ione two three", Enter, Keys "four five six", Escape, Keys "0k4dw" ]
            in
                [ test "5dw leaves cursorX where it was over multiple lines" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "5dw deletes words over multiple lines" <|
                    \_ ->
                        Expect.equal lines [ "five six" ]
                , test "5dw copies words into the buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "one two three", "four " ]
                ]
        , describe "deleting behind whitespace" <|
            let
                { lines, buffer } =
                    newStateAfterActions [ Keys "i one two three", Escape, Keys "0dw" ]
            in
                [ test "only delete to the next word boundary" <|
                    \_ ->
                        Expect.equal lines [ "one two three" ]
                , test "do copy when there's only whitespace" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ " " ]
                ]
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
