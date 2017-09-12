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


offsetTests : Test
offsetTests =
    describe "The first line offset."
        [ test "Offset starts at 0." <|
            \_ ->
                let
                    { firstLine } =
                        newStateAfterActions
                            [ Keys "ia", Enter, Keys "aaa", Escape, Keys "kh" ]
                in
                    Expect.equal firstLine 0
        , test "After 30 lines, the first line starts to increment." <|
            \_ ->
                let
                    { firstLine } =
                        newStateAfterActions <|
                            Keys "i"
                                :: List.repeat 32 Enter
                in
                    Expect.equal firstLine 2
        , test "When you navigate up using k, the first line will decrease when appropriate." <|
            \_ ->
                let
                    { firstLine } =
                        newStateAfterActions <|
                            [ Keys "i" ]
                                ++ (List.repeat 100 Enter)
                                ++ [ Escape, Keys <| String.repeat 50 "k" ]
                in
                    Expect.equal firstLine 50
        , test "When you navigate down, the first line will increase as well." <|
            \_ ->
                let
                    { firstLine } =
                        newStateAfterActions <|
                            [ Keys "i" ]
                                ++ (List.repeat 100 Enter)
                                ++ [ Escape, Keys <| String.repeat 50 "k", Keys <| String.repeat 50 "j" ]
                in
                    Expect.equal firstLine 70
        ]


wTests : Test
wTests =
    describe "The w key"
        [ test "w takes you to the start of the next word under normal circumstances." <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions
                            [ Keys "iaaa aaa", Escape, Keys "hhhhhhhhhhhhhhhhhw" ]
                in
                    Expect.equal cursorX 4
        , test "w takes you to the end of the line if it's all one word." <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions
                            [ Keys "iaaaaa", Escape, Keys "hhhhhhhhhhhhhhhhhw" ]
                in
                    Expect.equal cursorX 5
        , test "w takes you to the next line if there are more lines." <|
            \_ ->
                let
                    { cursorY } =
                        newStateAfterActions
                            [ Keys "iaaaaa", Enter, Keys "aaaaaa", Escape, Keys "khhhhhhhhhhhhhhhhhw" ]
                in
                    Expect.equal cursorY 1
        , test "w takes you to the start of the next line if there are more lines." <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions
                            [ Keys "iaaaaa", Enter, Keys "aaaaaa", Escape, Keys "khhhhhhhhhhhhhhhhhw" ]
                in
                    Expect.equal cursorX 0
        , test "w will skip empty lines." <|
            \_ ->
                let
                    { cursorY } =
                        newStateAfterActions
                            [ Keys "iaaaaa", Enter, Enter, Keys "aaaaaa", Escape, Keys "kkhhhhhhhhhhhhhhhhhw" ]
                in
                    Expect.equal cursorY 2
        ]


bTests : Test
bTests =
    describe "The b key"
        [ test "b takes you to the start of the next word under normal circumstances." <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions
                            [ Keys "iaaa aaa aaa", Escape, Keys "b" ]
                in
                    Expect.equal cursorX 8
        , test "This is another test" <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions
                            [ Keys "iaaa aaa aaa", Escape, Keys "bb" ]
                in
                    Expect.equal cursorX 4
        , test "Test that cursorX is sane at the start of the file" <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions
                            [ Keys "iaaa aaa aaa", Escape, Keys "bbbbbb" ]
                in
                    Expect.equal cursorX 0
        , test "Test that, also, cursorY is sane at the start of the file" <|
            \_ ->
                let
                    { cursorY } =
                        newStateAfterActions
                            [ Keys "iaaa aaa aaa", Escape, Keys "bbbbbb" ]
                in
                    Expect.equal cursorY 0
        , test "b takes you to the start of the line if it's all one word." <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions
                            [ Keys "iaaaaa", Escape, Keys "b" ]
                in
                    Expect.equal cursorX 0
        , test "b takes you to the previous line if there are previous lines." <|
            \_ ->
                let
                    { cursorY } =
                        newStateAfterActions
                            [ Keys "iaaaaa", Enter, Keys "aaaaaa", Escape, Keys "bb" ]
                in
                    Expect.equal cursorY 0
        , test "b takes you to the start of the next line if there are more lines." <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions
                            [ Keys "iaaaa aaa", Enter, Keys "aaaaaa", Escape, Keys "bb" ]
                in
                    Expect.equal cursorX 5
        , test "b will skip empty lines." <|
            \_ ->
                let
                    { cursorY } =
                        newStateAfterActions
                            [ Keys "iaaaaa", Enter, Enter, Keys "aaaaaa", Escape, Keys "bb" ]
                in
                    Expect.equal cursorY 0
        ]
