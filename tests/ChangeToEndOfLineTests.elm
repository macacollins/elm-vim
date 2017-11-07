module ChangeToEndOfLineTests exposing (..)

import Expect
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List
import Mode exposing (Mode(..))
import Model exposing (Model, PasteBuffer(..))


basicTests : Test
basicTests =
    describe "use C" <|
        [ let
            { lastAction, mode, lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "hhhC" ]
          in
            describe "hhhC"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "1234" ]
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "1234" ]
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "C"
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
            { lastAction, mode, lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i12341324", Escape, Keys "C", Escape ]
          in
            describe "C from line end"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "1234132" ]
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "4" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 6
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "C"
                ]
        , let
            { lastAction, mode, lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "0C", Escape ]
          in
            describe "0C"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "" ]
                , test "lastAction" <|
                    \_ ->
                        Expect.equal lastAction <| Keys "C"
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "12341234" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                ]
        ]
