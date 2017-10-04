module RedoTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List
import Util.ListUtils exposing (..)
import Mode exposing (Mode(..))


basicTest : Test
basicTest =
    describe "Redoing stuff."
        [ test "Redo text insert." <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "iHello world.", Escape, Keys "uR" ]
                in
                    Expect.equal lines [ "Hello world." ]
        , test "Redo text insert: cursorY." <|
            \_ ->
                let
                    { cursorY } =
                        newStateAfterActions [ Keys "iHello world.", Enter, Escape, Keys "uR" ]
                in
                    Expect.equal cursorY 1
        , test "Redo text insert: cursorX." <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions [ Keys "iHello world.", Enter, Keys "heh", Escape, Keys "uR" ]
                in
                    Expect.equal cursorX 2
        , test "Redo when text is deleted with dd." <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "iHello world.", Enter, Escape, Keys "dduR" ]
                in
                    Expect.equal (List.length lines) 1
        ]
