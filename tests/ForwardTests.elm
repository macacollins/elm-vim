module ForwardTests exposing (..)

import Expect
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List
import Model exposing (PasteBuffer(..))


navigationTests : Test
navigationTests =
    describe "forward using f key" <|
        [ let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "ddi123123123", Escape, Keys "0f3lf3" ]
          in
            describe "f from middle"
                [ test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 5
                , test "leaves cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "iasdfasdfasdf", Escape, Keys "0fd" ]
          in
            describe "single fd"
                [ test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 2
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "iasdfasdfasdf", Escape, Keys "0fdfdfd" ]
          in
            describe "multiple fd"
                [ test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 10
                , test "moves cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        ]



{- Delete forward tests:
   1. empty line
   2. end of line
   3. middle of line
   4. start of line
   5. multiple times
-}


deleteTests : Test
deleteTests =
    describe "deleting using df" <|
        [ let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i123412341234", Escape, Keys "hhhhhhdf2" ]
          in
            describe "deleting from middle of line"
                [ test "changes lines" <|
                    \_ ->
                        Expect.equal lines [ "1234134" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "23412" ]
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 5
                , test "moves cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "df" ]
          in
            describe "in empty buffer"
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
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i123412341234", Escape, Keys "0df4" ]
          in
            describe "from start"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "12341234" ]
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "1234" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i123412341234", Escape, Keys "0df3df3df3" ]
          in
            describe "z"
                [ test "changes lines" <|
                    \_ ->
                        Expect.equal lines [ "4" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "4123" ]
                , test " cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test " cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i123412341234", Escape, Keys "df4" ]
          in
            describe "deleting at end"
                [ test "changes lines" <|
                    \_ ->
                        Expect.equal lines [ "123412341234" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer []
                , test " cursorX" <|
                    \_ ->
                        Expect.equal cursorX 11
                , test " cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        ]


yankTests : Test
yankTests =
    describe "yanking with yf" <|
        [ let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i123412341234", Escape, Keys "0yf3" ]
          in
            describe "yf from start"
                [ test "leaves lines" <|
                    \_ ->
                        Expect.equal lines [ "123412341234" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "123" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "yf3" ]
          in
            describe "from empty line"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer []
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i123412341234", Escape, Keys "hhhhhhhyf3" ]
          in
            describe "yank from middle"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "123412341234" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "123" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 4
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i123412341234", Escape, Keys "yf4" ]
          in
            describe "yank from end"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "123412341234" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer []
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 11
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        ]
