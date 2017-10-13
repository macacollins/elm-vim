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


yankUpTests : Test
yankUpTests =
    describe "yanking up"
        [ describe "5yk" <|
            let
                { lines, cursorX, buffer, cursorY, inProgress } =
                    newStateAfterActions [ Keys "i1", Enter, Keys "2", Enter, Keys "3", Enter, Keys "45", Enter, Keys "6", Enter, Keys "7", Enter, Keys "8", Escape, Keys "5yk" ]
            in
                [ test "moves those lines into buffer" <|
                    \_ ->
                        Expect.equal lines [ "1", "2", "3", "45", "6", "7", "8" ]
                , test "copies 6 lines" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "2", "3", "45", "6", "7", "8" ]
                , test "clears inProgress" <|
                    \_ ->
                        Expect.equal inProgress []
                , test "leaves cursorX at 0" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "moves cursorY up" <|
                    \_ ->
                        Expect.equal cursorY 1
                ]
        , describe "single dj" <|
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
                { lines, cursorX, buffer, cursorY, inProgress } =
                    newStateAfterActions [ Keys "i1", Enter, Keys "2", Enter, Keys "3", Enter, Keys "45", Enter, Keys "6", Enter, Keys "7", Enter, Keys "8", Escape, Keys "gg5yk" ]
            in
                [ test "moves those lines into buffer" <|
                    \_ ->
                        Expect.equal lines [ "1", "2", "3", "45", "6", "7", "8" ]
                , test "copies 6 lines" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "1", "2", "3", "45", "6", "7" ]
                , test "clears inProgress" <|
                    \_ ->
                        Expect.equal inProgress []
                , test "leaves cursorX at 0" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "moves cursorY down" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , describe "single dj" <|
            let
                { lines, cursorX, buffer, cursorY } =
                    newStateAfterActions [ Keys "i1", Enter, Keys "2", Enter, Keys "3", Escape, Keys "ggyk" ]
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
