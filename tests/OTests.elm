module OTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List
import Util.ListUtils exposing (..)
import Mode exposing (Mode(..))


oTests : Test
oTests =
    describe "Hitting the o key."
        [ test "Should insert a new line after the first one." <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "o" ]
                in
                    Expect.equal (List.length lines) 2
        , test "Should move the cursor to the next line." <|
            \_ ->
                let
                    { cursorY } =
                        newStateAfterActions [ Keys "o" ]
                in
                    Expect.equal cursorY 1
        , test "Move cursor back to the start of the line." <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions [ Keys "o" ]
                in
                    Expect.equal cursorX 0
        , test "Should switch to insert mode." <|
            \_ ->
                let
                    { mode } =
                        newStateAfterActions [ Keys "o" ]
                in
                    Expect.equal mode Insert
        , test "New line should be empty even if there was stuff on the previous line" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "iaaaa", Escape, Keys "o" ]
                in
                    Expect.equal (getLine 1 lines) ""
        ]


capitalOTests : Test
capitalOTests =
    describe "Hitting the O key."
        [ test "Should add another line." <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "O" ]
                in
                    Expect.equal (List.length lines) 2
        , test "Should move cursorX back to 0" <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions [ Keys "iaaa", Escape, Keys "O" ]
                in
                    Expect.equal cursorX 0
        , test "Should switch to insert mode." <|
            \_ ->
                let
                    { mode } =
                        newStateAfterActions [ Keys "O" ]
                in
                    Expect.equal mode Insert
        ]
