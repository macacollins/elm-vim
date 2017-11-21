module ChangeTextTests exposing (..)

import Expect
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List
import Mode exposing (Mode(..))
import Model exposing (Model, PasteBuffer(..))
import Macro.ActionEntry exposing (ActionEntry(..))


changeToEndOfLineTests : Test
changeToEndOfLineTests =
    describe "c$-change to end of line" <|
        [ let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "c$" ]
          in
            describe "c$ in empty buffer"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "" ]
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1c$"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer []
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "hhhc$" ]
          in
            describe "hhhc$"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "1234" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1c$"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "1234" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 4
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "c$" ]
          in
            describe "c$"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "1234123" ]
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1c$"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "4" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 7
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "0c$" ]
          in
            describe "0c$"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "" ]
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1c$"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "12341234" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        ]


testChangeToBeginningOfLine : Test
testChangeToBeginningOfLine =
    describe "c0 tests" <|
        [ let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "c0" ]
          in
            describe "c0"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "4" ]
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1c0"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "1234123" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "c0" ]
          in
            describe "c0 in empty buffer"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "" ]
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1c0"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer []
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "hhhc0" ]
          in
            describe "hhhc0"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "1234" ]
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1c0"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "1234" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        ]


testChangeBackwardsToCharacter : Test
testChangeBackwardsToCharacter =
    describe "test cF" <|
        [ let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "cF3" ]
          in
            describe "cF3"
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
                newStateAfterActions [ Keys "i12341234", Escape, Keys "cF1" ]
          in
            describe "cF1"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "12344" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1cF1"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "123" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 4
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "hcF3" ]
          in
            describe "hcF3"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "1234" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1cF3"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "3412" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 2
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "0cF1" ]
          in
            describe "0cF1"
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
                        Expect.equal cursorX 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        ]


testChangeForwardToCharacter : Test
testChangeForwardToCharacter =
    describe "cf" <|
        [ let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "cf3" ]
          in
            describe "cf3 at end of line"
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
                        Expect.equal cursorX 7
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "hhhhhcf3" ]
          in
            describe "hhhhhcf3"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "124" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1cf3"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "34123" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 2
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "0cf3" ]
          in
            describe "0cf3"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "41234" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1cf3"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "123" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "cf3" ]
          in
            describe "cf3"
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


testGoBackwardsToCharacter : Test
testGoBackwardsToCharacter =
    describe "ct" <|
        [ let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i13241234", Escape, Keys "ct1" ]
          in
            describe "ct1 at end of line"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "13241234" ]
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
                        Expect.equal cursorX 7
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "0ct1" ]
          in
            describe "0ct1"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "1234" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1ct1"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "1234" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341324", Escape, Keys "hhhct2" ]
          in
            describe "hhhct2"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "123424" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1ct2"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "13" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 4
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "ct3" ]
          in
            describe "ct3"
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


testGoBackwardsTilCharacter : Test
testGoBackwardsTilCharacter =
    describe "cT" <|
        [ let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i13241234", Escape, Keys "cT1" ]
          in
            describe "cT1 at end of line"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "132414" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1cT1"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "23" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 5
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "0cT1" ]
          in
            describe "0cT1"
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
                        Expect.equal cursorX 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341324", Escape, Keys "hhhcT2" ]
          in
            describe "hhhcT2"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "121324" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1cT2"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "34" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 2
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "cT3" ]
          in
            describe "cT3"
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


changeWordTests : Test
changeWordTests =
    describe "cw tests" <|
        [ let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i1 2 3", Enter, Keys "4 5 6", Escape, Keys "kcw" ]
          in
            describe "kcw"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "1 2 ", "4 5 6" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1cw"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "3" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 4
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12 34 56 78", Escape, Keys "cw" ]
          in
            describe "cw"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "12 34 56 7" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1cw"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "8" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 10
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12 34 56 78", Escape, Keys "0cw" ]
          in
            describe "0cw"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ " 34 56 78" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1cw"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "12" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12 34 56 78", Escape, Keys "bbcw" ]
          in
            describe "bbcw"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "12 34  78" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1cw"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "56" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 6
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "cw" ]
          in
            describe "cw in empty buffer"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1cw"
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
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i1 2     3 5", Escape, Keys "hbbcw" ]
          in
            describe "hbbcw"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "1      3 5" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1cw"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "2" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 2
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        ]



{-
   TODO uncomment these when we're ready to handle multiple words.

   change3WordsTests : Test
   change3WordsTests =
       describe "c3w tests" <|
           [ let
               { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                   newStateAfterActions [ Keys "c3w" ]
             in
               describe "c3w in empty buffer"
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
                   newStateAfterActions [ Keys "i23 45 67 89", Escape, Keys "0c3w" ]
             in
               describe "0c3w"
                   [ test "lines" <|
                       \_ ->
                           Expect.equal lines [ " 89" ]
                   , test "numberBuffer" <|
                       \_ ->
                           Expect.equal numberBuffer []
                   , test "lastAction" <|
                       \_ ->
                           Expect.equal lastAction <| Keys "c3w"
                   , test "buffer" <|
                       \_ ->
                           Expect.equal buffer <| LinesBuffer [ "23 45 67" ]
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
                   newStateAfterActions [ Keys "i12 34 56", Enter, Keys "78 90 12", Escape, Keys "kc3w" ]
             in
               describe "kc3w multiple lines"
                   [ test "lines" <|
                       \_ ->
                           Expect.equal lines [ "12 34 5 12" ]
                   , test "numberBuffer" <|
                       \_ ->
                           Expect.equal numberBuffer []
                   , test "lastAction" <|
                       \_ ->
                           Expect.equal lastAction <| Keys "c3w"
                   , test "buffer" <|
                       \_ ->
                           Expect.equal buffer <| LinesBuffer [ "6", "78 90" ]
                   , test "cursorX" <|
                       \_ ->
                           Expect.equal cursorX 7
                   , test "cursorY" <|
                       \_ ->
                           Expect.equal cursorY 0
                   , test "mode" <|
                       \_ ->
                           Expect.equal mode Insert
                   ]
           , let
               { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                   newStateAfterActions [ Keys "i12 34 56", Enter, Keys "78 90", Escape, Keys "k0c3w" ]
             in
               describe "k0c3w"
                   [ test "lines" <|
                       \_ ->
                           Expect.equal lines [ "", "78 90" ]
                   , test "numberBuffer" <|
                       \_ ->
                           Expect.equal numberBuffer []
                   , test "lastAction" <|
                       \_ ->
                           Expect.equal lastAction <| Keys "c3w"
                   , test "buffer" <|
                       \_ ->
                           Expect.equal buffer <| InlineBuffer [ "12 34 56" ]
                   , test "cursorX" <|
                       \_ ->
                           Expect.equal cursorX 0
                   , test "cursorY" <|
                       \_ ->
                           Expect.equal cursorY 0
                   , test "mode" <|
                       \_ ->
                           Expect.equal mode Insert
                   ]
           , let
               { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                   newStateAfterActions [ Keys "i12 34 56 78 90 11", Escape, Keys "bbbbbc3w" ]
             in
               describe "bbbbbc3w"
                   [ test "lines" <|
                       \_ ->
                           Expect.equal lines [ "12  90 11" ]
                   , test "numberBuffer" <|
                       \_ ->
                           Expect.equal numberBuffer []
                   , test "lastAction" <|
                       \_ ->
                           Expect.equal lastAction <| Keys "c3w"
                   , test "buffer" <|
                       \_ ->
                           Expect.equal buffer <| LinesBuffer [ "34 56 78" ]
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
                   newStateAfterActions [ Keys "i12", Enter, Keys "34", Enter, Keys "56", Enter, Keys "78", Escape, Keys "ggc3w" ]
             in
               describe "ggc3w"
                   [ test "lines" <|
                       \_ ->
                           Expect.equal lines [ "", "78" ]
                   , test "numberBuffer" <|
                       \_ ->
                           Expect.equal numberBuffer []
                   , test "lastAction" <|
                       \_ ->
                           Expect.equal lastAction <| Keys ""
                   , test "buffer" <|
                       \_ ->
                           Expect.equal buffer <| InlineBuffer [ "12", "34", "56" ]
                   , test "cursorX" <|
                       \_ ->
                           Expect.equal cursorX 3
                   , test "cursorY" <|
                       \_ ->
                           Expect.equal cursorY 0
                   , test "mode" <|
                       \_ ->
                           Expect.equal mode Insert
                   ]
           , let
               { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                   newStateAfterActions [ Keys "i123", Enter, Enter, Enter, Enter, Enter, Keys "456", Escape, Keys "kkkkkbc3w" ]
             in
               describe "kkkkkbc3w"
                   [ test "lines" <|
                       \_ ->
                           Expect.equal lines [ "" ]
                   , test "numberBuffer" <|
                       \_ ->
                           Expect.equal numberBuffer []
                   , test "lastAction" <|
                       \_ ->
                           Expect.equal lastAction <| Keys "c3w"
                   , test "buffer" <|
                       \_ ->
                           Expect.equal buffer <| InlineBuffer [ "123", "", "", "", "", "456" ]
                   , test "cursorX" <|
                       \_ ->
                           Expect.equal cursorX 0
                   , test "cursorY" <|
                       \_ ->
                           Expect.equal cursorY 0
                   , test "mode" <|
                       \_ ->
                           Expect.equal mode Insert
                   ]
           , let
               { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                   newStateAfterActions [ Keys "i", Enter, Enter, Keys "1 2 3", Escape, Keys "kc3w" ]
             in
               describe "kc3w"
                   [ test "lines" <|
                       \_ ->
                           Expect.equal lines [ "", "3" ]
                   , test "numberBuffer" <|
                       \_ ->
                           Expect.equal numberBuffer []
                   , test "lastAction" <|
                       \_ ->
                           Expect.equal lastAction <| Keys "c3w"
                   , test "buffer" <|
                       \_ ->
                           Expect.equal buffer <| InlineBuffer [ "", "1 2 " ]
                   , test "cursorX" <|
                       \_ ->
                           Expect.equal cursorX 0
                   , test "cursorY" <|
                       \_ ->
                           Expect.equal cursorY 1
                   , test "mode" <|
                       \_ ->
                           Expect.equal mode Insert
                   ]
           ]
-}
{-
   changeBackWordTests : Test
   changeBackWordTests =
       describe "cb tests" <|
           [ let
               { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                   newStateAfterActions [ Keys "i1 2 3", Enter, Keys "4 5 6", Escape, Keys "0cb" ]
             in
               describe "0cb at start of second line"
                   [ test "lines" <|
                       \_ ->
                           Expect.equal lines [ "1 2 ", "4 5 6" ]
                   , test "numberBuffer" <|
                       \_ ->
                           Expect.equal numberBuffer []
                   , test "lastAction" <|
                       \_ ->
                           Expect.equal lastAction <| Keys "cb"
                   , test "buffer" <|
                       \_ ->
                           Expect.equal buffer <| InlineBuffer [ "3" ]
                   , test "cursorX" <|
                       \_ ->
                           Expect.equal cursorX 4
                   , test "cursorY" <|
                       \_ ->
                           Expect.equal cursorY 0
                   , test "mode" <|
                       \_ ->
                           Expect.equal mode Insert
                   ]
           , let
               { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                   newStateAfterActions [ Keys "i12 34 56 78", Escape, Keys "cb" ]
             in
               describe "cb"
                   [ test "lines" <|
                       \_ ->
                           Expect.equal lines [ "12 34 56 8" ]
                   , test "numberBuffer" <|
                       \_ ->
                           Expect.equal numberBuffer []
                   , test "lastAction" <|
                       \_ ->
                           Expect.equal lastAction <| Keys "cb"
                   , test "buffer" <|
                       \_ ->
                           Expect.equal buffer <| LinesBuffer [ "7" ]
                   , test "cursorX" <|
                       \_ ->
                           Expect.equal cursorX 10
                   , test "cursorY" <|
                       \_ ->
                           Expect.equal cursorY 0
                   , test "mode" <|
                       \_ ->
                           Expect.equal mode Insert
                   ]
           , let
               { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                   newStateAfterActions [ Keys "i12 34 56 78", Escape, Keys "bcb" ]
             in
               describe "bcb"
                   [ test "lines" <|
                       \_ ->
                           Expect.equal lines [ "12 34 78" ]
                   , test "numberBuffer" <|
                       \_ ->
                           Expect.equal numberBuffer []
                   , test "lastAction" <|
                       \_ ->
                           Expect.equal lastAction <| Keys "cb"
                   , test "buffer" <|
                       \_ ->
                           Expect.equal buffer <| LinesBuffer [ "56 " ]
                   , test "cursorX" <|
                       \_ ->
                           Expect.equal cursorX 6
                   , test "cursorY" <|
                       \_ ->
                           Expect.equal cursorY 0
                   , test "mode" <|
                       \_ ->
                           Expect.equal mode Insert
                   ]
           , let
               { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                   newStateAfterActions [ Keys "cb" ]
             in
               describe "cb in empty buffer"
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
                   newStateAfterActions [ Keys "i1 2     3 5", Escape, Keys "hbcb" ]
             in
               describe "hbcb"
                   [ test "lines" <|
                       \_ ->
                           Expect.equal lines [ "1 3 5" ]
                   , test "numberBuffer" <|
                       \_ ->
                           Expect.equal numberBuffer []
                   , test "lastAction" <|
                       \_ ->
                           Expect.equal lastAction <| Keys "cb"
                   , test "buffer" <|
                       \_ ->
                           Expect.equal buffer <| InlineBuffer [ "2     " ]
                   , test "cursorX" <|
                       \_ ->
                           Expect.equal cursorX 2
                   , test "cursorY" <|
                       \_ ->
                           Expect.equal cursorY 0
                   , test "mode" <|
                       \_ ->
                           Expect.equal mode Insert
                   ]
           ]


   changeBack3WordsTests : Test
   changeBack3WordsTests =
       describe "c3b tests" <|
           [ let
               { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                   newStateAfterActions [ Keys "c3b" ]
             in
               describe "c3b in empty buffer"
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
                   newStateAfterActions [ Keys "i23 45 67 89", Escape, Keys "c3b" ]
             in
               describe "0c3w"
                   [ test "lines" <|
                       \_ ->
                           Expect.equal lines [ "23 9" ]
                   , test "numberBuffer" <|
                       \_ ->
                           Expect.equal numberBuffer []
                   , test "lastAction" <|
                       \_ ->
                           Expect.equal lastAction <| Keys "c3b"
                   , test "buffer" <|
                       \_ ->
                           Expect.equal buffer <| LinesBuffer [ "45 67 8" ]
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
                   newStateAfterActions [ Keys "i12 34 56", Enter, Keys "78 90 12", Escape, Keys "kc3b" ]
             in
               describe "kc3b"
                   [ test "lines" <|
                       \_ ->
                           Expect.equal lines [ "6", "78 90 12" ]
                   , test "numberBuffer" <|
                       \_ ->
                           Expect.equal numberBuffer []
                   , test "lastAction" <|
                       \_ ->
                           Expect.equal lastAction <| Keys "c3b"
                   , test "buffer" <|
                       \_ ->
                           Expect.equal buffer <| LinesBuffer [ "12 34 5" ]
                   , test "cursorX" <|
                       \_ ->
                           Expect.equal cursorX 0
                   , test "cursorY" <|
                       \_ ->
                           Expect.equal cursorY 0
                   , test "mode" <|
                       \_ ->
                           Expect.equal mode Insert
                   ]
           , let
               { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                   newStateAfterActions [ Keys "i12 34 56", Enter, Keys "78 90", Escape, Keys "0c3b" ]
             in
               describe "0c3b"
                   [ test "lines" <|
                       \_ ->
                           Expect.equal lines [ "", "78 90" ]
                   , test "numberBuffer" <|
                       \_ ->
                           Expect.equal numberBuffer []
                   , test "lastAction" <|
                       \_ ->
                           Expect.equal lastAction <| Keys "c3b"
                   , test "buffer" <|
                       \_ ->
                           Expect.equal buffer <| InlineBuffer [ "12 34 56" ]
                   , test "cursorX" <|
                       \_ ->
                           Expect.equal cursorX 0
                   , test "cursorY" <|
                       \_ ->
                           Expect.equal cursorY 0
                   , test "mode" <|
                       \_ ->
                           Expect.equal mode Insert
                   ]
           , let
               { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                   newStateAfterActions [ Keys "i12 34 56 78 90 11", Escape, Keys "bbbc3b" ]
             in
               describe "bbbbbc3w"
                   [ test "lines" <|
                       \_ ->
                           Expect.equal lines [ "12 90 11" ]
                   , test "numberBuffer" <|
                       \_ ->
                           Expect.equal numberBuffer []
                   , test "lastAction" <|
                       \_ ->
                           Expect.equal lastAction <| Keys "c3b"
                   , test "buffer" <|
                       \_ ->
                           Expect.equal buffer <| LinesBuffer [ "34 56 78 " ]
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
                   newStateAfterActions [ Keys "i12", Enter, Keys "34", Enter, Keys "56", Enter, Keys "78", Escape, Keys "c3b" ]
             in
               describe "ggc3w"
                   [ test "lines" <|
                       \_ ->
                           Expect.equal lines [ "12", "8" ]
                   , test "numberBuffer" <|
                       \_ ->
                           Expect.equal numberBuffer []
                   , test "lastAction" <|
                       \_ ->
                           Expect.equal lastAction <| Keys "c3b"
                   , test "buffer" <|
                       \_ ->
                           Expect.equal buffer <| InlineBuffer [ "34", "56", "7" ]
                   , test "cursorX" <|
                       \_ ->
                           Expect.equal cursorX 0
                   , test "cursorY" <|
                       \_ ->
                           Expect.equal cursorY 1
                   , test "mode" <|
                       \_ ->
                           Expect.equal mode Insert
                   ]
           , let
               { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                   newStateAfterActions [ Keys "i123", Enter, Enter, Enter, Enter, Enter, Keys "456", Escape, Keys "bc3b" ]
             in
               describe "bc3b"
                   [ test "lines" <|
                       \_ ->
                           Expect.equal lines [ "123", "", "", "456" ]
                   , test "numberBuffer" <|
                       \_ ->
                           Expect.equal numberBuffer []
                   , test "lastAction" <|
                       \_ ->
                           Expect.equal lastAction <| Keys "c3b"
                   , test "buffer" <|
                       \_ ->
                           Expect.equal buffer <| InlineBuffer [ "", "", "" ]
                   , test "cursorX" <|
                       \_ ->
                           Expect.equal cursorX 0
                   , test "cursorY" <|
                       \_ ->
                           Expect.equal cursorY 2
                   , test "mode" <|
                       \_ ->
                           Expect.equal mode Insert
                   ]
           , let
               { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                   newStateAfterActions [ Keys "i", Enter, Enter, Keys "1 2 3", Escape, Keys "c3b" ]
             in
               describe "c3b"
                   [ test "lines" <|
                       \_ ->
                           Expect.equal lines [ "", "3" ]
                   , test "numberBuffer" <|
                       \_ ->
                           Expect.equal numberBuffer []
                   , test "lastAction" <|
                       \_ ->
                           Expect.equal lastAction <| Keys "c3b"
                   , test "buffer" <|
                       \_ ->
                           Expect.equal buffer <| InlineBuffer [ "", "1 2 " ]
                   , test "cursorX" <|
                       \_ ->
                           Expect.equal cursorX 0
                   , test "cursorY" <|
                       \_ ->
                           Expect.equal cursorY 1
                   , test "mode" <|
                       \_ ->
                           Expect.equal mode Insert
                   ]
           ]

-}


changeDownLineTests : Test
changeDownLineTests =
    describe "cj tests" <|
        [ let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i1", Enter, Keys "2", Enter, Keys "3", Escape, Keys "ggcj" ]
          in
            describe "ggcj"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "", "3" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1cj"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "1", "2" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i1234", Escape, Keys "cj" ]
          in
            describe "cj"
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
                newStateAfterActions [ Keys "i1", Enter, Keys "2", Enter, Keys "3", Enter, Keys "4", Enter, Keys "5", Escape, Keys "gg3cj" ]
          in
            describe "gg3cj"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "", "5" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "3cj"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "1", "2", "3", "4" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i", Enter, Keys "1", Enter, Keys "2", Escape, Keys "kc3j" ]
          in
            describe "kc3j"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "", "1", "2" ]
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
                        Expect.equal cursorY 1
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        ]


changeUpLineTests : Test
changeUpLineTests =
    describe "ck tests" <|
        [ let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i1", Enter, Keys "2", Enter, Keys "3", Escape, Keys "ck" ]
          in
            describe "ck"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "1", "" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1ck"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "2", "3" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 1
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i1234", Escape, Keys "ck" ]
          in
            describe "ck only one line"
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
                newStateAfterActions [ Keys "i1", Enter, Keys "2", Enter, Keys "3", Enter, Keys "4", Enter, Keys "5", Escape, Keys "3ck" ]
          in
            describe "3ck"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "1", "" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "3ck"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "2", "3", "4", "5" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 1
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i", Enter, Keys "1", Enter, Keys "2", Escape, Keys "kc3k" ]
          in
            describe "kc3k"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "", "1", "2" ]
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
                        Expect.equal cursorY 1
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        ]


changeLeftTests : Test
changeLeftTests =
    describe "ch tests" <|
        [ let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "ch" ]
          in
            describe "ch single line"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "1234124" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1ch"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "3" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 6
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "0ch" ]
          in
            describe "0ch"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "12341234" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1ch"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer []
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "c3h" ]
          in
            describe "c3h"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "12344" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "3ch"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "123" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 4
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "0llc3h" ]
          in
            describe "0llc3h"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "341234" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "3ch"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "12" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        ]


changeRightTests : Test
changeRightTests =
    describe "cl tests" <|
        [ let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "cl" ]
          in
            describe "cl"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "1234123" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1cl"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "4" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 7
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "0cl" ]
          in
            describe "0cl"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "2341234" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1cl"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "1" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "c3l" ]
          in
            describe "c3l"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "1234123" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "3cl"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "4" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 7
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "0c3l" ]
          in
            describe "0llc3l"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "41234" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "3cl"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "123" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        ]


changeToStartOfBufferTests : Test
changeToStartOfBufferTests =
    describe "cgg tests" <|
        [ let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12", Enter, Keys "34", Enter, Keys "56", Escape, Keys "kkcgg" ]
          in
            describe "cG on last line"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "", "34", "56" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "cgg"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "12" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12", Enter, Keys "34", Enter, Keys "56", Escape, Keys "kcgg" ]
          in
            describe "kcgg"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "", "56" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "cgg"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "12", "34" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "cgg" ]
          in
            describe "cgg in empty buffer"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "cgg"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "hhhhcgg" ]
          in
            describe "hhhhcgg"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "cgg"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "12341234" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12", Enter, Keys "34", Enter, Keys "567890", Enter, Keys "12", Escape, Keys "klcgg" ]
          in
            describe "klcgg"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "", "12" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "cgg"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <|
                            LinesBuffer
                                [ "12"
                                , "34"
                                , "567890"
                                ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        ]


changeToEndOfBuffer : Test
changeToEndOfBuffer =
    describe "cG tests" <|
        [ let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12", Enter, Keys "34", Enter, Keys "56", Escape, Keys "cG" ]
          in
            describe "cG on last line"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "12", "34", "" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "cG"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "56" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 2
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12", Enter, Keys "34", Enter, Keys "56", Escape, Keys "kcG" ]
          in
            describe "kcG"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "12", "" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "cG"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "34", "56" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 1
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "cG" ]
          in
            describe "cG"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "cG"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "hhhhcG" ]
          in
            describe "hhhhcG"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "cG"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "12341234" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12", Enter, Keys "34", Enter, Keys "567890", Enter, Keys "12", Escape, Keys "klcG" ]
          in
            describe "klcG"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "12", "34", "" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "cG"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <|
                            LinesBuffer
                                [ "567890"
                                , "12"
                                ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 2
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        ]


changeToEndOfWordTests : Test
changeToEndOfWordTests =
    describe "ce tests" <|
        [ let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12 34 56", Escape, Keys "bbce" ]
          in
            describe "bbce"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "12  56" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1ce"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "34" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 3
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12 34 56 78", Escape, Keys "ce" ]
          in
            describe "ce"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "12 34 56 7" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1ce"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "8" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 10
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12", Enter, Keys "34", Enter, Enter, Enter, Keys "56", Escape, Keys "kkkce" ]
          in
            describe "kkkce"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "12", "3" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1ce"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <|
                            InlineBuffer
                                [ "4"
                                , ""
                                , ""
                                , "56"
                                ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 1
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 1
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, numberBuffer, lastAction, cursorY } =
                newStateAfterActions [ Keys "i12", Enter, Keys "34", Enter, Enter, Enter, Keys "56", Escape, Keys "kkkde" ]
          in
            describe "kkkde"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "12", "3" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1de"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <|
                            InlineBuffer
                                [ "4"
                                , ""
                                , ""
                                , "56"
                                ]
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
                newStateAfterActions [ Keys "ce" ]
          in
            describe "ce in empty buffer"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "" ]
                , test "numberBuffer" <|
                    \_ ->
                        Expect.equal numberBuffer []
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "1ce"
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
                        Expect.equal mode Insert
                ]
        ]
