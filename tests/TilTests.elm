module TilTests exposing (..)

import Expect
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List
import Model exposing (PasteBuffer(..))


navigateUsingT : Test
navigateUsingT =
    describe "t" <|
        [ let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i12345", Escape, Keys "t5" ]
          in
            describe "t5 when already at 5"
                [ test "changes lines" <|
                    \_ ->
                        Expect.equal lines [ "12345" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 4
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i123123", Escape, Keys "0t3t3t3t3t3t3t3" ]
          in
            describe "many t3s"
                [ test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 1
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i123123", Escape, Keys "0t3" ]
          in
            describe "to 3 when there are multiple 3s"
                [ test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 1
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i12345", Escape, Keys "0t5" ]
          in
            describe "go to 5 from start of line"
                [ test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 3
                ]
        ]


deleteTests : Test
deleteTests =
    describe "deleting using dt" <|
        [ let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i123123", Escape, Keys "0dt3dt3" ]
          in
            describe "deleting multiple times"
                [ test "changes lines" <|
                    \_ ->
                        Expect.equal lines [ "3" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "312" ]
                , test "leaves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "leaves cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i12345", Escape, Keys "0dt3" ]
          in
            describe "single dt from start"
                [ test "changes lines" <|
                    \_ ->
                        Expect.equal lines [ "345" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "12" ]
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "leaves cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i12345", Escape, Keys "dt3" ]
          in
            describe "dt from end"
                [ test "changes lines" <|
                    \_ ->
                        Expect.equal lines [ "12345" ]
                , test "doesn't copy anything" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer []
                , test "leaves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 4
                , test "leaves cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        ]


yankTests : Test
yankTests =
    describe "yanking using yt" <|
        [ let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i123123", Escape, Keys "0yt3yt3" ]
          in
            describe "yanking multiple times"
                [ test "leaves lines" <|
                    \_ ->
                        Expect.equal lines [ "123123" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "12" ]
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "moves cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i12345", Escape, Keys "0yt3" ]
          in
            describe "yanking once from start"
                [ test "leaves lines" <|
                    \_ ->
                        Expect.equal lines [ "12345" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "12" ]
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "moves cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i12345", Escape, Keys "yt3" ]
          in
            describe "yanking from past the item"
                [ test "leaves lines" <|
                    \_ ->
                        Expect.equal lines [ "12345" ]
                , test "doesn't copy anything" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer []
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 4
                , test "moves cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        ]
