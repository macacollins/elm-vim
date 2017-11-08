module EndOfWordTests exposing (..)

import Expect
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List
import Mode exposing (Mode(..))
import Model exposing (Model, PasteBuffer(..))


endOfWordTests : Test
endOfWordTests =
    describe "e" <|
        [ let
            { mode, lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "e" ]
          in
            describe "empty buffer"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "" ]
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer []
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i1234", Escape, Keys "e" ]
          in
            describe "e at end of line"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "1234" ]
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer []
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 3
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i1234 1234", Escape, Keys "0e" ]
          in
            describe "0e"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "1234 1234" ]
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer []
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 3
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i12 34 56", Escape, Keys "bbbee" ]
          in
            describe "bbbee"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "12 34 56" ]
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer []
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 4
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i12", Enter, Keys "34", Escape, Keys "ke" ]
          in
            describe "ke"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "12", "34" ]
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer []
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 1
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 1
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        ]


test3e : Test
test3e =
    describe "number modifier with e" <|
        [ let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "3e" ]
          in
            describe "3e"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys ""
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer []
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12 34 56", Escape, Keys "03e" ]
          in
            describe "03e on single line"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "12 34 56" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 7
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i1234", Escape, Keys "3e" ]
          in
            describe "3e at end of buffer"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "1234" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys ""
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer []
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 3
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12 34", Escape, Keys "03e" ]
          in
            describe "03e without enough words"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "12 34" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys ""
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 4
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i1", Enter, Keys "2", Escape, Keys "k3e" ]
          in
            describe "k3e over multiple lines"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "1", "2" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys ""
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 1
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i", Enter, Enter, Enter, Enter, Escape, Keys "0gg3e" ]
          in
            describe "0gg3e"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "", "", "", "", "" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys ""
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 4
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i", Enter, Keys "1 2", Escape, Keys "k3e" ]
          in
            describe "k3e"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "", "1 2" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 2
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 1
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        ]


deleteToEndOfWordTests : Test
deleteToEndOfWordTests =
    describe "d3e" <|
        [ let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "3de" ]
          in
            describe "3de in empty buffer"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "3de"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i1 23 4", Escape, Keys "d3e" ]
          in
            describe "d3e with almost enough words"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "1 23 " ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "3de"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "4" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 4
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i1 2 3 4 5", Escape, Keys "0d3e" ]
          in
            describe "0d3e with enough words"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ " 5" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "3de"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "1 2 3 4" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i1", Enter, Enter, Keys "2", Enter, Enter, Keys "3", Escape, Keys "ggde" ]
          in
            describe
                "ggde over empty lines"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "", "3" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1de"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "1", "", "2" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i1 2", Escape, Keys "0d3e" ]
          in
            describe "0d3e without enough words"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "3de"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "1 2" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        ]


yankToEndOfLineTests : Test
yankToEndOfLineTests =
    describe "y3e" <|
        [ let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "3ye" ]
          in
            describe "3ye in empty buffer"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys ""
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i1 23 4", Escape, Keys "y3e" ]
          in
            describe "y3e with almost enough words"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "1 23 4" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys ""
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "4" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 5
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i1 2 3 4 5", Escape, Keys "0y3e" ]
          in
            describe "0y3e with enough words"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "1 2 3 4 5" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys ""
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "1 2 3 4" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i1", Enter, Enter, Keys "2", Enter, Enter, Keys "3", Escape, Keys "ggye" ]
          in
            describe "ggye over empty lines"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "1", "", "2", "", "3" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys ""
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "1", "", "2" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i1 2", Escape, Keys "0y3e" ]
          in
            describe "0y3e without enough words"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "1 2" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys ""
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "1 2" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        ]
