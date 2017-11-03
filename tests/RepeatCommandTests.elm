module RepeatCommandTests exposing (..)

import Expect
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List
import Mode exposing (Mode(..))
import Model exposing (Model, PasteBuffer(..))


repeatActionTests : Test
repeatActionTests =
    describe "Repeating actions with ." <|
        [ let
            { mode, lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "ifirst", Enter, Keys "second", Escape, Keys "dd." ]
          in
            describe "dd."
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "" ]
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "first" ]
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "ddyyp." ]
          in
            describe "ddyyp."
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "", "", "" ]
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 2
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        , let
            { mode, lines, cursorX, buffer, cursorY, lastAction } =
                newStateAfterActions [ Keys "i1", Enter, Keys "2", Enter, Keys "3", Enter, Keys "4", Enter, Keys "5", Escape, Keys "dk." ]
          in
            describe "dk."
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "1" ]
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction (Keys "1dk")
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "2", "3" ]
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
                newStateAfterActions [ Keys "i1", Enter, Keys "2", Enter, Keys "3", Enter, Keys "4", Escape, Keys "k2yyP." ]
          in
            describe "k2yyP."
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "1", "2", "3", "4", "3", "4", "3", "4" ]
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "3", "4" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 2
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Control
                ]
        ]
