module NavigateBackTilTests exposing (..)

import Expect
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List
import Mode exposing (Mode(..))
import Model exposing (Model, PasteBuffer(..))
import Macro.ActionEntry exposing (ActionEntry(..))


basicNavigationTests : Test
basicNavigationTests =
    describe "Navigation backwards with T" <|
        [ let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "T2" ]
          in
            describe "T2"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "12341234" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys ""
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 6
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "T2T2" ]
          in
            describe "T2T2"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "12341234" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys ""
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 6
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "0T2" ]
          in
            describe "0T2"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "12341234" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys ""
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "hhT2" ]
          in
            describe "hhT2"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "12341234" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys ""
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 2
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "Tq" ]
          in
            describe "Tq"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "12341234" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys ""
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 7
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "T3" ]
          in
            describe "T3"
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
        ]


deleteBackwardsTilTests : Test
deleteBackwardsTilTests =
    describe "deleting backwards using T" <|
        [ let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "dT1" ]
          in
            describe "dT1"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "123414" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "dT1"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "23" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 5
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "dT1dT1" ]
          in
            describe "dT1dT1"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "123414" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys ""
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "23" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 5
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "0dT1" ]
          in
            describe "0dT1"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "12341234" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "don't set lastAction if it didn't change the buffer" <|
                    \_ ->
                        Expect.equal lastAction <| Keys ""
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer []
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "dT4" ]
          in
            describe "dT4"
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
                newStateAfterActions [ Keys "i12341234", Escape, Keys "hdT4" ]
          in
            describe "hdT4"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "123434" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "dT4"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "12" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 4
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        ]


yankBackwardsTilTests : Test
yankBackwardsTilTests =
    describe "yanking backwards using T" <|
        [ let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "yT1" ]
          in
            describe "yT1"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "12341234" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys ""
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "23" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 5
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "yT1yT1" ]
          in
            describe "yT1yT1"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "12341234" ]
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
                        Expect.equal cursorX 5
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "0yT1" ]
          in
            describe "0yT1"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "12341234" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "don't set lastAction if it didn't change the buffer" <|
                    \_ ->
                        Expect.equal lastAction <| Keys ""
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer []
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "yT4" ]
          in
            describe "yT4"
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
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "hyT4" ]
          in
            describe "hyT4"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "12341234" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys ""
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "12" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 4
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        ]
