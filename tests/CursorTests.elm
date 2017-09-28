module CursorTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List


testBang : Test
testBang =
    describe "Test my bangs."
        [ test "Hitting $ takes you to the end of the line." <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions [ Keys "iaaaaa", Escape, Keys "hhhhhhhhhhhhhh$" ]
                in
                    Expect.equal cursorX 5
        ]


testH : Test
testH =
    describe "Testing the h key"
        [ test "takes cursorY to the top of the screen" <|
            \_ ->
                let
                    { cursorY } =
                        newStateAfterActions <|
                            [ Keys "i" ]
                                ++ (List.repeat 35 Enter)
                                ++ [ Escape, Keys "H" ]
                in
                    Expect.equal cursorY 5
        ]


testG : Test
testG =
    let
        actionsWith100Lines =
            (Keys "i" :: List.repeat 100 Enter)
                ++ [ Escape, Keys <| String.repeat 100 "k" ]
                ++ [ Keys "G" ]

        modelWith100Lines =
            newStateAfterActions actionsWith100Lines
    in
        describe "The G key."
            [ test "basic movement." <|
                \_ ->
                    let
                        { cursorY } =
                            modelWith100Lines
                    in
                        Expect.equal cursorY 100
            , test "Also moves the window down." <|
                \_ ->
                    let
                        { firstLine } =
                            modelWith100Lines
                    in
                        Expect.equal firstLine 70
            , test "When the window has few lines, the cursor still moves to the last line" <|
                \_ ->
                    let
                        { cursorY } =
                            newStateAfterActions [ Keys "iaaaaaa", Enter, Enter, Enter, Escape, Keys "ggG" ]
                    in
                        Expect.equal cursorY 3
            , test "Big G moves cursor X to the last position on the last line" <|
                \_ ->
                    let
                        { cursorX } =
                            newStateAfterActions [ Keys "iaaaaaa", Enter, Enter, Enter, Keys "aaa", Escape, Keys "ggG" ]
                    in
                        Expect.equal cursorX 3
            , test "When the window has few lines, the first line stays at 0" <|
                \_ ->
                    let
                        { firstLine } =
                            newStateAfterActions [ Keys "i", Enter, Enter, Enter, Escape, Keys "G" ]
                    in
                        Expect.equal firstLine 0
            ]


testLittleG : Test
testLittleG =
    let
        actionsWith100Lines =
            (Keys "i" :: List.repeat 100 Enter)
                ++ [ Keys "aa", Escape, Keys "gg" ]

        modelWith100Lines =
            newStateAfterActions actionsWith100Lines

        actionsWith100LinesOneG =
            (Keys "i" :: List.repeat 100 Enter)
                ++ [ Escape, Keys "g" ]

        modelWith100LinesOneG =
            newStateAfterActions actionsWith100LinesOneG
    in
        describe "The little g key."
            [ test "One g goes to in progress." <|
                \_ ->
                    let
                        { inProgress } =
                            modelWith100LinesOneG
                    in
                        Expect.equal inProgress [ 'g' ]
            , test "One g doesn't move anything." <|
                \_ ->
                    let
                        { firstLine } =
                            modelWith100LinesOneG
                    in
                        Expect.equal firstLine 70
            , test "move cursorX back to 0!" <|
                \_ ->
                    let
                        { cursorX } =
                            newStateAfterActions [ Keys "iaaaaaa", Enter, Enter, Enter, Keys "aaaaa", Escape, Keys "gg" ]
                    in
                        Expect.equal cursorX 0
            , test "One g doesn't move the cursorY ." <|
                \_ ->
                    let
                        { cursorY } =
                            modelWith100LinesOneG
                    in
                        Expect.equal cursorY 100
            , test "2 gs does move anything." <|
                \_ ->
                    let
                        { firstLine } =
                            modelWith100Lines
                    in
                        Expect.equal firstLine 0
            , test "2 gs does move the cursorY ." <|
                \_ ->
                    let
                        { cursorY } =
                            modelWith100Lines
                    in
                        Expect.equal cursorY 0
            , test "2 gs does move the cursorX ." <|
                \_ ->
                    let
                        { cursorX } =
                            modelWith100Lines
                    in
                        Expect.equal cursorX 0
            ]


test0 : Test
test0 =
    describe "Test my 0."
        [ test "hitting 0 takes you to the start of the line" <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions [ Keys "iaaaaaaaaaa", Escape, Keys "0" ]
                in
                    Expect.equal cursorX 0
        ]


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
        , test "h takes modifier numbers" <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions
                            [ Keys "iaaaaa", Escape, Keys "2h" ]
                in
                    Expect.equal cursorX 3
        , test "h resets the inProgress buffer." <|
            \_ ->
                let
                    { inProgress } =
                        newStateAfterActions
                            [ Keys "iaaaaa", Escape, Keys "2h" ]
                in
                    Expect.equal inProgress []
        , test "Too many h leaves the cursor at 0" <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions
                            [ Keys "iaaaaa", Escape, Keys "3000h" ]
                in
                    Expect.equal cursorX 0
        ]


lTests : Test
lTests =
    describe "The l key."
        [ test "Cursor doesn't go past the end of the line" <|
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
                -- This tests whether the solution manifests Elm's current issues with Arrays
                -- Down the road if we switch implementations of Elm and it's not fixed,
                -- this will trigger again
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
        , test "L key takes modifiers" <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions
                            [ Keys "iaaaaa", Escape, Keys "gg3l" ]
                in
                    Expect.equal cursorX 3
        , test "L key clears inProgress buffer" <|
            \_ ->
                let
                    { inProgress } =
                        newStateAfterActions
                            [ Keys "iaaaaa", Escape, Keys "gg3l" ]
                in
                    Expect.equal inProgress []
        , test "Too many ls doesn't go past the end of the line" <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions
                            [ Keys "iaaaaa", Escape, Keys "gg3000l" ]
                in
                    Expect.equal cursorX 5
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


jTests : Test
jTests =
    describe "The j key."
        [ test "j takes modifiers " <|
            \_ ->
                let
                    { cursorY } =
                        newStateAfterActions
                            [ Keys "i", Enter, Enter, Enter, Escape, Keys "gg2j" ]
                in
                    Expect.equal cursorY 2
        , test "j clears out inProgress" <|
            \_ ->
                let
                    { inProgress } =
                        newStateAfterActions
                            [ Keys "i", Enter, Enter, Enter, Escape, Keys "gg2j" ]
                in
                    Expect.equal inProgress []
        , test "too many j's doesn't go below the bottom of the screen" <|
            \_ ->
                let
                    { cursorY } =
                        newStateAfterActions
                            [ Keys "i", Enter, Enter, Enter, Enter, Escape, Keys "gg2000j" ]
                in
                    Expect.equal cursorY 4
        ]


kTests : Test
kTests =
    describe "The k key."
        [ test "k takes modifiers " <|
            \_ ->
                let
                    { cursorY } =
                        newStateAfterActions
                            [ Keys "i", Enter, Enter, Enter, Enter, Escape, Keys "2k" ]
                in
                    Expect.equal cursorY 2
        , test "k clears out inProgress" <|
            \_ ->
                let
                    { inProgress } =
                        newStateAfterActions
                            [ Keys "i", Enter, Enter, Enter, Escape, Keys "2k" ]
                in
                    Expect.equal inProgress []
        , test "too many ks doesn't go above the top of the screen" <|
            \_ ->
                let
                    { cursorY } =
                        newStateAfterActions
                            [ Keys "i", Enter, Enter, Enter, Escape, Keys "2000k" ]
                in
                    Expect.equal cursorY 0
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
        , test "test behavior of w with a cursor past the end of the line" <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions
                            [ Keys "iaaa aaa aaa", Enter, Keys "aaa a", Enter, Keys "a", Escape, Keys "kklllllllllllllllllllllljw" ]
                in
                    Expect.equal cursorX 0
        , test "w takes a number arg" <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions
                            [ Keys "iaaa aaa aaa", Escape, Keys "gg2w" ]
                in
                    Expect.equal cursorX 8
        , test "w resets the inProgress buffer properly." <|
            \_ ->
                let
                    { inProgress } =
                        newStateAfterActions
                            [ Keys "iaaa aaa aaa", Escape, Keys "gg2w" ]
                in
                    Expect.equal inProgress []
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
        [ test "b takes you to the start of the last word under normal circumstances." <|
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
        , test "test behavior of b with a cursor past the end of the line" <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions
                            [ Keys "iaaa aaa aaa", Enter, Keys "aaa a", Escape, Keys "klllllllllllllllllllllljb" ]
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
        , test "b takes modifier keys" <|
            \_ ->
                let
                    { cursorX } =
                        newStateAfterActions
                            [ Keys "iaaa aaa aaa", Escape, Keys "3b" ]
                in
                    Expect.equal cursorX 0
        , test "b clears out inProgress" <|
            \_ ->
                let
                    { inProgress } =
                        newStateAfterActions
                            [ Keys "iaaa aaa aaa", Escape, Keys "3b" ]
                in
                    Expect.equal inProgress []
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
