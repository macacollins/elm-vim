module UndoTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Actions exposing (ActionEntry(..), newStateAfterActions)
import List
import Util.ListUtils exposing (..)
import Mode exposing (Mode(..))


basicTest : Test
basicTest =
    describe "Undoing stuff."
        [ test "Undo text insert." <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "iHello world.", Escape, Keys "u" ]
                in
                    Expect.equal lines [ "" ]
        , test "Undo text insert: cursorY." <|
            \_ ->
                let
                    { cursorY } =
                        newStateAfterActions [ Keys "iHello world.", Enter, Escape, Keys "u" ]
                in
                    Expect.equal cursorY 0
        , test "Undo text insert: cursorX." <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions [ Keys "iHello world.", Enter, Escape, Keys "u" ]
                in
                    Expect.equal cursorX 0
        , test "Undo when text is deleted with dd." <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "iHello world.", Enter, Escape, Keys "ddu" ]
                in
                    Expect.equal (List.length lines) 2
        ]
