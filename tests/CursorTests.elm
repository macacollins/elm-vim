module CursorTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Actions exposing (ActionEntry(..), newStateAfterActions)
import List


testCursor : Test
testCursor =
    describe "Basic Cursor Movement"
        [ test "Increments on input" <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions
                            [ Keys "iaaa" ]
                in
                    Expect.equal cursorX 3
        , test "Resets on Enter key" <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions
                            [ Keys "iaaa", Enter ]
                in
                    Expect.equal cursorX 0
        , test "Cursor doesn't go negative" <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions
                            [ Keys "iaaa", Escape, Keys "hhhhhhhhhhhhhhhhhhhhh" ]
                in
                    Expect.equal cursorX 0
        , test "Cursor doesn't go past the end of the line" <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions
                            [ Keys "iaaa", Escape, Keys "hhhllllllllllllllllllllllllll" ]
                in
                    Expect.equal cursorX 3
        , test "Cursor on 0 length line doesn't go to -1 on l." <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions
                            [ Keys "i", Enter, Escape, Keys "kl" ]
                in
                    Expect.equal cursorX 0
        , test "When the enter key is pressed 34 times, no error occurs." <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions <|
                            Keys "i"
                                :: List.repeat 34 Enter
                in
                    Expect.equal (List.length lines) 35
        , test "Cursor on 0 length line doesn't go to -1 on h." <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions
                            [ Keys "i", Enter, Keys "aaaaaaaaa", Escape, Keys "kh" ]
                in
                    Expect.equal cursorX 0
        , test "Cursor resets on l key." <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions
                            [ Keys "iaa", Enter, Keys "aaaa", Escape, Keys "kl" ]
                in
                    Expect.equal cursorX 2
        , test "Cursor resets on h key." <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions
                            [ Keys "ia", Enter, Keys "aaa", Escape, Keys "kh" ]
                in
                    Expect.equal cursorX 0
        , test "Cursor sticks around for k key." <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions
                            [ Keys "iaaa", Enter, Enter, Keys "aaa", Escape, Keys "kk" ]
                in
                    Expect.equal cursorX 3
        ]
