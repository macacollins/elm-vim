module MacroTests exposing (..)

import Dict
import Mode exposing (Mode(..))
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import Macro.Model exposing (getMacro)
import List
import Util.ListUtils exposing (getLine)


macroRunTests : Test
macroRunTests =
    describe "Macro Run"
        [ test "simple run" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "qqia", Escape, Keys "q@q" ]

                    line =
                        getLine 0 lines
                in
                    Expect.equal line "aa"
        ]


macroBufferTests : Test
macroBufferTests =
    describe "Macro Buffer"
        [ test "Add to buffer" <|
            \_ ->
                let
                    { macroModel } =
                        newStateAfterActions [ Keys "qqa" ]
                in
                    Expect.equal macroModel.buffer [ Keys "a" ]
        , test "Add multiple chars to buffer" <|
            \_ ->
                let
                    { macroModel } =
                        newStateAfterActions [ Keys "qqaa" ]
                in
                    Expect.equal macroModel.buffer [ Keys "aa" ]
        , test "Add Enter to buffer." <|
            \_ ->
                let
                    { macroModel } =
                        newStateAfterActions [ Keys "qqaa", Enter ]
                in
                    Expect.equal macroModel.buffer [ Keys "aa", Enter ]
        , test "Add keys to buffer after Enter." <|
            \_ ->
                let
                    { macroModel } =
                        newStateAfterActions [ Keys "qqaa", Enter, Keys "aa" ]
                in
                    Expect.equal macroModel.buffer [ Keys "aa", Enter, Keys "aa" ]
        , test "Add keys to buffer in proper order." <|
            \_ ->
                let
                    { macroModel } =
                        newStateAfterActions [ Keys "qqab", Enter, Keys "cd" ]
                in
                    Expect.equal macroModel.buffer [ Keys "ab", Enter, Keys "cd" ]
        , test "Clear buffer when exiting macro recording." <|
            \_ ->
                let
                    { macroModel } =
                        newStateAfterActions [ Keys "qqab", Enter, Keys "cd", Escape, Keys "q" ]
                in
                    Expect.equal macroModel.buffer []
        , test "Clear out raw buffer as well" <|
            \_ ->
                let
                    { macroModel } =
                        newStateAfterActions [ Keys "qqiab", Enter, Keys "cd", Escape, Keys "q" ]
                in
                    Expect.equal macroModel.rawBuffer []
        ]


macroKeyTests : Test
macroKeyTests =
    describe "Record whatever key gets put in"
        [ test "Test i doesn't switch to insert mode" <|
            \_ ->
                let
                    { mode } =
                        newStateAfterActions [ Keys "qi" ]
                in
                    Expect.equal mode <| Macro 'i' Control
        , test "Test that non-characters are ignored " <|
            \_ ->
                let
                    { mode } =
                        newStateAfterActions [ Keys "q", Enter ]
                in
                    Expect.equal mode Control
        , test "Test that numbers are ok " <|
            \_ ->
                let
                    { mode } =
                        newStateAfterActions [ Keys "q3" ]
                in
                    Expect.equal mode <| Macro '3' Control
        ]


macroModeTests : Test
macroModeTests =
    describe "Switching to macro mode"
        [ test "enter macro" <|
            \_ ->
                let
                    { mode } =
                        newStateAfterActions [ Keys "qq" ]
                in
                    Expect.equal mode (Macro 'q' Control)
        , test "test enter macro without q." <|
            \_ ->
                let
                    { mode } =
                        newStateAfterActions [ Keys "qg" ]
                in
                    Expect.equal mode (Macro 'g' Control)
        , test "exit macro" <|
            \_ ->
                let
                    { mode } =
                        newStateAfterActions [ Keys "qqq" ]
                in
                    Expect.equal mode Control
        , test "change mode to insert inside macro" <|
            \_ ->
                let
                    { mode } =
                        newStateAfterActions [ Keys "qqi" ]
                in
                    Expect.equal mode (Macro 'q' Insert)
        , test "change mode back to control from insert inside macro" <|
            \_ ->
                let
                    { mode } =
                        newStateAfterActions [ Keys "qqi", Escape ]
                in
                    Expect.equal mode (Macro 'q' Control)
        , test "change mode to search inside macro" <|
            \_ ->
                let
                    { mode } =
                        newStateAfterActions [ Keys "qq/" ]
                in
                    Expect.equal mode (Macro 'q' Search)
        , test "change mode to back to control from search inside macro" <|
            \_ ->
                let
                    { mode } =
                        newStateAfterActions [ Keys "qq/", Enter ]
                in
                    Expect.equal mode (Macro 'q' Control)
        ]
