module YankTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Model exposing (PasteBuffer(..))
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List
import Util.ListUtils exposing (..)
import Mode exposing (Mode(..))


yankTests : Test
yankTests =
    describe "Yank it"
        [ test "Basic yankin'" <|
            \_ ->
                let
                    { buffer } =
                        newStateAfterActions [ Keys "ia", Escape, Keys "yy" ]
                in
                    Expect.equal buffer <| LinesBuffer [ "a" ]
        , test "Yank 2" <|
            \_ ->
                let
                    { buffer } =
                        newStateAfterActions [ Keys "i1", Enter, Keys "2", Enter, Keys "3", Escape, Keys "gg2yy" ]
                in
                    Expect.equal buffer <| LinesBuffer [ "1", "2" ]
        , test "Yank doesn't go past the end of the buffer" <|
            \_ ->
                let
                    { buffer } =
                        newStateAfterActions [ Keys "i1", Enter, Keys "2", Enter, Keys "3", Escape, Keys "gg200yy" ]
                in
                    Expect.equal buffer <| LinesBuffer [ "1", "2", "3" ]
        ]


yankToEndOfLineTests : Test
yankToEndOfLineTests =
    describe "yanking to end of line"
        [ describe "y$ from middle of line" <|
            let
                { lines, cursorX, buffer, cursorY } =
                    newStateAfterActions [ Keys "i1234567", Escape, Keys "hhhy$" ]
            in
                [ test "y$ deletes two lines" <|
                    \_ ->
                        Expect.equal lines [ "1234567" ]
                , test "y$ copies the rest of the line" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "4567" ]
                , test "y$ leaves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 3
                , test "y$ leaves cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        ]


yankLines : Test
yankLines =
    describe "Yank using Y" <|
        [ let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i1234", Escape, Keys "Y" ]
          in
            describe "Y"
                [ test "leaves line" <|
                    \_ ->
                        Expect.equal lines [ "1234" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "1234" ]
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 3
                , test "moves cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        ]


yankToLineTests : Test
yankToLineTests =
    describe "ygg"
        [ describe "navigate to line 5" <|
            let
                { lines, cursorX, buffer, cursorY } =
                    newStateAfterActions [ Keys "i1", Enter, Keys "2", Enter, Keys "3", Enter, Keys "4", Enter, Keys "5", Enter, Keys "6", Enter, Keys "7", Enter, Keys "8", Enter, Keys "9", Escape, Keys "5ygg" ]
            in
                [ test "ygg leaves lines" <|
                    \_ ->
                        Expect.equal lines [ "1", "2", "3", "4", "5", "6", "7", "8", "9" ]
                , test "ygg copies the deleted word" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "5", "6", "7", "8", "9" ]
                , test "ygg leaves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "ygg moves cursorY up if 5 is higher than the number" <|
                    \_ ->
                        Expect.equal cursorY 4
                ]
        ]


yankToEndOfFileTests : Test
yankToEndOfFileTests =
    describe "yG" <|
        [ let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i1", Enter, Keys "2", Enter, Keys "3", Enter, Keys "4", Enter, Keys "5", Enter, Keys "6", Enter, Keys "7", Enter, Keys "8", Enter, Keys "9", Escape, Keys "ggyG" ]
          in
            describe "ggyG"
                [ test "doesn't change lines" <|
                    \_ ->
                        Expect.equal lines [ "1", "2", "3", "4", "5", "6", "7", "8", "9" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "1", "2", "3", "4", "5", "6", "7", "8", "9" ]
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "moves cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i1", Enter, Keys "2", Enter, Keys "3", Enter, Keys "4", Enter, Keys "5", Escape, Keys "d", Escape, Keys "yG" ]
          in
            describe "yG from last line"
                [ test "doesn't change lines" <|
                    \_ ->
                        Expect.equal lines [ "1", "2", "3", "4", "5" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "5" ]
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "moves cursorY" <|
                    \_ ->
                        Expect.equal cursorY 4
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "yG" ]
          in
            describe "yG in empty buffer"
                [ test "changes lines" <|
                    \_ ->
                        Expect.equal lines [ "" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "" ]
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "moves cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i1", Enter, Keys "2", Enter, Keys "3", Enter, Keys "4", Enter, Keys "5", Enter, Keys "6", Escape, Keys "kkkyG" ]
          in
            describe "copy from midway through the file"
                [ test "changes lines" <|
                    \_ ->
                        Expect.equal lines [ "1", "2", "3", "4", "5", "6" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "3", "4", "5", "6" ]
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "moves cursorY" <|
                    \_ ->
                        Expect.equal cursorY 2
                ]
        ]


yankToStartOfLineTests : Test
yankToStartOfLineTests =
    describe "y0"
        [ describe "y0 from end of line" <|
            let
                { lines, cursorX, buffer, numberBuffer, cursorY } =
                    newStateAfterActions [ Keys "i1234567", Escape, Keys "y0" ]
            in
                [ test "y0 leaves the line" <|
                    \_ ->
                        Expect.equal lines [ "1234567" ]
                , test "y0 has an empty numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "y0 copies text" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "123456" ]
                , test "y0 moves cursorX back " <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "y0 moves cursorY back " <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , describe "y20 doesn't copy text" <|
            let
                { lines, cursorX, buffer, numberBuffer, cursorY } =
                    newStateAfterActions [ Keys "i1234567", Escape, Keys "y20" ]
            in
                [ test "y20 leaves the line" <|
                    \_ ->
                        Expect.equal lines [ "1234567" ]
                , test "y20 copies text" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer []
                , test "y20 has 2 and 0 numberBuffer" <|
                    \_ ->
                        Expect.equal (List.member '2' numberBuffer && List.member '0' numberBuffer) True
                , test "y20 moves cursorX back " <|
                    \_ ->
                        Expect.equal cursorX 6
                , test "y20 doesn't move cursor" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        ]


yankLeftTests : Test
yankLeftTests =
    describe "yanking left"
        [ describe "3yh" <|
            let
                { lines, cursorX, buffer, cursorY } =
                    newStateAfterActions [ Keys "i1234567", Escape, Keys "3yh" ]
            in
                [ test "3yh leaves the line" <|
                    \_ ->
                        Expect.equal lines [ "1234567" ]
                , test "3yh copies characters into the buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "456" ]
                , test "3yh moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 3
                , test "3yh leaves cursorY when on one line" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        ]


yankRightTests : Test
yankRightTests =
    describe "y3l"
        [ describe "single y3l" <|
            let
                { lines, cursorX, buffer, cursorY } =
                    newStateAfterActions [ Keys "i1234567", Escape, Keys "0y3l" ]
            in
                [ test "y3l leaves lines" <|
                    \_ ->
                        Expect.equal lines [ "1234567" ]
                , test "y3l copies the characters" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "123" ]
                , test "y3l leaves cursorX  " <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "y3l leaves cursorY " <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        ]


yankUpTests : Test
yankUpTests =
    describe "yanking up"
        [ describe "5yk" <|
            let
                { lines, cursorX, buffer, cursorY, numberBuffer } =
                    newStateAfterActions [ Keys "i1", Enter, Keys "2", Enter, Keys "3", Enter, Keys "45", Enter, Keys "6", Enter, Keys "7", Enter, Keys "8", Escape, Keys "5yk" ]
            in
                [ test "moves those lines into buffer" <|
                    \_ ->
                        Expect.equal lines [ "1", "2", "3", "45", "6", "7", "8" ]
                , test "copies 6 lines" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "2", "3", "45", "6", "7", "8" ]
                , test "clears numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "leaves cursorX at 0" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "moves cursorY up" <|
                    \_ ->
                        Expect.equal cursorY 1
                ]
        , describe "single yk" <|
            let
                { lines, cursorX, buffer, cursorY } =
                    newStateAfterActions [ Keys "i1", Enter, Keys "2", Enter, Keys "3", Escape, Keys "yk" ]
            in
                [ test "leaves the normal text contents" <|
                    \_ ->
                        Expect.equal lines [ "1", "2", "3" ]
                , test "copies two lines into buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "2", "3" ]
                , test "leaves cursorX at 0" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "moves cursorY up" <|
                    \_ ->
                        Expect.equal cursorY 1
                ]
        , describe "test copying too far up" <|
            let
                { lines, cursorX, buffer, cursorY } =
                    newStateAfterActions [ Keys "jkji1", Enter, Keys "2", Enter, Keys "3", Escape, Keys "400yk" ]
            in
                [ test "leaves lines" <|
                    \_ ->
                        Expect.equal lines [ "1", "2", "3" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "1", "2", "3" ]
                , test "leaves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "moves cursorY but not past the start" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , describe "test yanking from mid-line" <|
            let
                { lines, cursorX, buffer, cursorY } =
                    newStateAfterActions [ Keys "i1234", Enter, Keys "1234", Enter, Keys "1234", Escape, Keys "hy3k" ]
            in
                [ test "doesn't change lines" <|
                    \_ ->
                        Expect.equal lines [ "1234", "1234", "1234" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "1234", "1234", "1234" ]
                , test "leaves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 2
                , test "moves cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        ]


yankDownTests : Test
yankDownTests =
    describe "yanking down"
        [ describe "5yj" <|
            let
                { lines, cursorX, buffer, cursorY, numberBuffer } =
                    newStateAfterActions [ Keys "i1", Enter, Keys "2", Enter, Keys "3", Enter, Keys "45", Enter, Keys "6", Enter, Keys "7", Enter, Keys "8", Escape, Keys "gg5yj" ]
            in
                [ test "moves those lines into buffer" <|
                    \_ ->
                        Expect.equal lines [ "1", "2", "3", "45", "6", "7", "8" ]
                , test "copies 6 lines" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "1", "2", "3", "45", "6", "7" ]
                , test "clears numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "leaves cursorX at 0" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "moves cursorY down" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , describe "single yj" <|
            let
                { lines, cursorX, buffer, cursorY } =
                    newStateAfterActions [ Keys "i1", Enter, Keys "2", Enter, Keys "3", Escape, Keys "ggyj" ]
            in
                [ test "leaves the normal text contents" <|
                    \_ ->
                        Expect.equal lines [ "1", "2", "3" ]
                , test "copies two lines into buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "1", "2" ]
                , test "leaves cursorX at 0" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "moves cursorY up" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , describe "test copying too far down" <|
            let
                { lines, cursorX, buffer, cursorY } =
                    newStateAfterActions [ Keys "jkji1", Enter, Keys "2", Enter, Keys "3", Escape, Keys "gg400yj" ]
            in
                [ test "leaves lines" <|
                    \_ ->
                        Expect.equal lines [ "1", "2", "3" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "1", "2", "3" ]
                , test "leaves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "moves cursorY but not past the start" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , describe "test yanking from mid-line" <|
            let
                { lines, cursorX, buffer, cursorY } =
                    newStateAfterActions [ Keys "i1234", Enter, Keys "1234", Enter, Keys "1234", Escape, Keys "kkhy3j" ]
            in
                [ test "doesn't change lines" <|
                    \_ ->
                        Expect.equal lines [ "1234", "1234", "1234" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "1234", "1234", "1234" ]
                , test "leaves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 2
                , test "moves cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        ]


yankWordsTest : Test
yankWordsTest =
    describe "yankin' words"
        [ describe "yank 3 words" <|
            let
                { lines, cursorX, buffer, cursorY } =
                    newStateAfterActions [ Keys "i1 2 3 4 5 6 7", Escape, Keys "0y3w" ]
            in
                [ test "y3w leaves lines" <|
                    \_ ->
                        Expect.equal lines [ "1 2 3 4 5 6 7" ]
                , test "y3w yanks three words " <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "1 2 3 " ]
                , test "y3w leaves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "y3w leaves cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , describe "single yw" <|
            let
                { lines, cursorX, buffer, cursorY } =
                    newStateAfterActions [ Keys "i1 2 3 4 5 6 7", Escape, Keys "0yw" ]
            in
                [ test "yw leaves lines" <|
                    \_ ->
                        Expect.equal lines [ "1 2 3 4 5 6 7" ]
                , test "yw yanks one word" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "1 " ]
                , test "yw leaves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "yw leaves cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , describe "test over multiple lines" <|
            let
                { lines, cursorX, buffer, cursorY } =
                    newStateAfterActions [ Keys "i1 2 3", Enter, Keys "4 5 6", Enter, Keys "7", Enter, Keys "8", Enter, Keys "9", Escape, Keys "ggy8w" ]
            in
                [ test "doesn't change lines" <|
                    \_ ->
                        Expect.equal lines [ "1 2 3", "4 5 6", "7", "8", "9" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "1 2 3", "4 5 6", "7", "8" ]
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "moves cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        ]


yankWordsBackTests : Test
yankWordsBackTests =
    describe "yanking words backwards"
        [ describe "single yb" <|
            let
                { lines, cursorX, buffer, cursorY } =
                    newStateAfterActions [ Keys "i1 23", Backspace, Keys " 3 4 5 6 7 8 9", Escape, Keys "yb" ]
            in
                [ test "yb leaves lines" <|
                    \_ ->
                        Expect.equal lines [ "1 2 3 4 5 6 7 8 9" ]
                , test "yb copies the word" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "8 " ]
                , test "yb moves cursorX back " <|
                    \_ ->
                        Expect.equal cursorX 14
                , test "yb leaves cursorY " <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , describe "triple yb" <|
            let
                { lines, cursorX, buffer, cursorY } =
                    newStateAfterActions [ Keys "i1 23", Backspace, Keys " 3 4 5 6 7 8 9", Escape, Keys "3yb" ]
            in
                [ test "3yb leaves lines" <|
                    \_ ->
                        Expect.equal lines [ "1 2 3 4 5 6 7 8 9" ]
                , test "3yb copies the word" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "6 7 8 " ]
                , test "3yb moves cursorX back " <|
                    \_ ->
                        Expect.equal cursorX 10
                , test "3yb leaves cursorY " <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , describe "yb over multiple lines" <|
            let
                { lines, cursorX, buffer, cursorY } =
                    newStateAfterActions [ Keys "i1", Enter, Keys "2", Enter, Keys "3 4 5", Escape, Keys "y3b" ]
            in
                [ test "3yb leaves lines" <|
                    \_ ->
                        Expect.equal lines [ "1", "2", "3 4 5" ]
                , test "3yb copies the word" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "2", "3 4 " ]
                , test "3yb moves cursorX back " <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "3yb moves cursorY " <|
                    \_ ->
                        Expect.equal cursorY 1
                ]
        ]
