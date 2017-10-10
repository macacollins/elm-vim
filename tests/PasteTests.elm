module PasteTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Util.ListUtils exposing (..)
import Model exposing (PasteBuffer(..))
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))


-- TODO also handle capital P. It's already crossed off the list :D


pasteBeforeTests : Test
pasteBeforeTests =
    describe "Paste before"
        [ test "Basic paste." <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "iaa", Escape, Keys "ddP" ]
                in
                    Expect.equal (getLine 0 lines) "aa"
        , test "paste makes an extra line." <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "iaa", Escape, Keys "ddP" ]
                in
                    Expect.equal lines [ "aa", "" ]
        , test "paste cursor y." <|
            \_ ->
                let
                    { cursorY } =
                        newStateAfterActions [ Keys "iaa", Escape, Keys "ddP" ]
                in
                    Expect.equal cursorY 0
        , test "paste partial buffer before maintains existing lines" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "iaa", Escape, Keys "0DpppP" ]
                in
                    Expect.equal lines [ "aaaaaaaa" ]
        , test "paste cursor x." <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions [ Keys "iaa", Escape, Keys "ddP" ]
                in
                    Expect.equal cursorX 0
        , test "paste a partial buffer properly" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "iaaabb", Enter, Keys "bbbcc", Enter, Keys "cccdd", Escape, Keys "0llvklx0P" ]
                in
                    Expect.equal lines [ "aaabb", "cc", "cccbbbdd" ]
        ]


pTests : Test
pTests =
    describe "basic paste"
        [ test "Basic paste." <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "iaa", Escape, Keys "ddp" ]
                in
                    Expect.equal (getLine 1 lines) "aa"
        , test "paste in empty lines with empty buffer doesn't do anything" <|
            \_ ->
                let
                    { cursorY } =
                        newStateAfterActions [ Keys "p" ]
                in
                    Expect.equal cursorY 0
        , test "paste cursor y." <|
            \_ ->
                let
                    { cursorY } =
                        newStateAfterActions [ Keys "iaa", Escape, Keys "ddp" ]
                in
                    Expect.equal cursorY 1
        , test "paste cursor x." <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions [ Keys "iaa", Escape, Keys "ddp" ]
                in
                    Expect.equal cursorX 0
        , test "Load a partial buffer properly" <|
            \_ ->
                let
                    { buffer } =
                        newStateAfterActions [ Keys "iaaabb", Enter, Keys "bbbcc", Enter, Keys "cccdd", Escape, Keys "0llvklx0p" ]
                in
                    Expect.equal buffer <| InlineBuffer [ "cc", "ccc" ]
        , test "paste a partial buffer properly" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "iaaabb", Enter, Keys "bbbcc", Enter, Keys "cccdd", Escape, Keys "0llvklx0p" ]
                in
                    Expect.equal lines [ "aaabb", "bcc", "cccbbdd" ]
        , test "pasting a single line doesn't move the cursor down past the end" <|
            \_ ->
                let
                    { cursorY } =
                        newStateAfterActions [ Keys "iaaabb", Escape, Keys "0Dp" ]
                in
                    Expect.equal cursorY 0
        , test "pasting a single line " <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions [ Keys "iaaabb", Escape, Keys "0Dp" ]
                in
                    Expect.equal cursorX 4
        , test "pasting a single line preserves the second part of the line" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "iaaabb", Escape, Keys "0Dp0p" ]
                in
                    Expect.equal lines [ "aaaabbaabb" ]
        ]
