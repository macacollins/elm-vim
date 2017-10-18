module SubstituteLineTests exposing (..)

import Expect
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List
import Model exposing (Model, PasteBuffer(..))
import Mode exposing (Mode(..))


substituteLineTests : Test
substituteLineTests =
    describe "capital S--substitute line" <|
        [ let
            { lines, cursorX, buffer, cursorY, mode } =
                newStateAfterActions [ Keys "S" ]
          in
            describe "empty buffer"
                [ test "goes to insert mode" <|
                    \_ ->
                        Expect.equal mode Insert
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "moves cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , let
            { lines, cursorX, buffer, cursorY, mode } =
                newStateAfterActions [ Keys "i123412341234", Escape, Keys "S" ]
          in
            describe "single line"
                [ test "changes lines" <|
                    \_ ->
                        Expect.equal lines [ "" ]
                , test "moves to insert mode" <|
                    \_ ->
                        Expect.equal mode Insert
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "123412341234" ]
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "moves cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i1", Enter, Keys "2", Enter, Keys "3", Enter, Keys "4", Enter, Keys "5", Escape, Keys "kkS" ]
          in
            describe "middle line"
                [ test "changes lines" <|
                    \_ ->
                        Expect.equal lines [ "1", "2", "", "4", "5" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "3" ]
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "moves cursorY" <|
                    \_ ->
                        Expect.equal cursorY 2
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i1", Enter, Keys "2", Enter, Keys "3", Enter, Keys "4", Enter, Keys "5", Escape, Keys "kk2S" ]
          in
            describe "S with modifier keys"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "1", "2", "", "5" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer [ "3", "4" ]
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "moves cursorY" <|
                    \_ ->
                        Expect.equal cursorY 2
                ]
        ]
