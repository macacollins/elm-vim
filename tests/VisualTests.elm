module VisualTests exposing (..)

import Expect
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import Mode exposing (Mode(..))
import Model exposing (PasteBuffer(..))
import List
import Util.ListUtils exposing (getLine)


testVisualModeSwitching : Test
testVisualModeSwitching =
    describe "visual mode switches properly"
        [ test "Add visual coordinates when hitting v" <|
            \_ ->
                let
                    { mode } =
                        newStateAfterActions
                            [ Keys "v" ]
                in
                    Expect.equal mode <| Visual 0 0
        , test "set y properly" <|
            \_ ->
                let
                    { mode } =
                        newStateAfterActions
                            [ Keys "i", Enter, Enter, Enter, Enter, Enter, Escape, Keys "v" ]
                in
                    Expect.equal mode <| Visual 0 5
        , test "set x properly" <|
            \_ ->
                let
                    { mode } =
                        newStateAfterActions
                            [ Keys "iaaaaa", Escape, Keys "v" ]
                in
                    Expect.equal mode <| Visual 4 0
        ]


testVisualMode : Test
testVisualMode =
    describe "visual mode"
        [ test "Test with x" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions
                            [ Keys "ia b c d", Escape, Keys "0vwx", Escape, Keys "$p" ]

                    line =
                        getLine 0 lines
                in
                    Expect.equal line " c da b"
        , test "buffer properly after x" <|
            \_ ->
                let
                    { buffer } =
                        newStateAfterActions
                            [ Keys "ia b c d", Escape, Keys "0vwx" ]
                in
                    Expect.equal buffer <| InlineBuffer [ "a b" ]
        , test "buffer multiple lines properly after x" <|
            \_ ->
                let
                    { buffer } =
                        newStateAfterActions
                            [ Keys "iaaabb", Enter, Keys "bbbbc", Escape, Keys "gglllvjx" ]
                in
                    Expect.equal buffer <| InlineBuffer [ "bb", "bbbb" ]
        , test "Load a partial buffer properly backwards with multiple lines" <|
            \_ ->
                let
                    { buffer } =
                        newStateAfterActions [ Keys "iaaabb", Enter, Keys "bbbcc", Enter, Keys "cccdd", Escape, Keys "0llvklx0p" ]
                in
                    Expect.equal buffer <| InlineBuffer [ "cc", "ccc" ]
        , test "remove multiple lines properly" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions
                            [ Keys "iaaabb", Enter, Keys "bbbbc", Escape, Keys "gglllvjx" ]
                in
                    Expect.equal lines [ "aaac" ]
        , test "buffer 3 lines properly after x" <|
            \_ ->
                let
                    { buffer } =
                        newStateAfterActions
                            [ Keys "iaaabb", Enter, Keys "bbbbb", Enter, Keys "bbbbc", Escape, Keys "gglllvjjx" ]
                in
                    Expect.equal buffer <| InlineBuffer [ "bb", "bbbbb", "bbbb" ]
        , test "remove 3 lines properly" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions
                            [ Keys "iaaabb", Enter, Keys "bbbbb", Enter, Keys "bbbbc", Escape, Keys "gglllvjjx" ]
                in
                    Expect.equal lines [ "aaac" ]
        , test "do multiple lines properly in reverse" <|
            \_ ->
                let
                    { buffer } =
                        newStateAfterActions
                            [ Keys "iaaabb", Enter, Keys "bbbbb", Enter, Keys "bbbbc", Escape, Keys "hvkkx" ]
                in
                    Expect.equal buffer <| InlineBuffer [ "bb", "bbbbb", "bbbb" ]
        , test "remove 3 lines properly in reverse" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions
                            [ Keys "iaaabb", Enter, Keys "bbbbb", Enter, Keys "bbbbc", Escape, Keys "hvkkx" ]
                in
                    Expect.equal lines [ "aaac" ]
        , test "buffer properly going backwards on one line" <|
            \_ ->
                let
                    { buffer } =
                        newStateAfterActions
                            [ Keys "iaaabb", Escape, Keys "vhx" ]
                in
                    Expect.equal buffer <| InlineBuffer [ "bb" ]
        , test "remove text properly going backwards on a single line" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions
                            [ Keys "iaaabb", Escape, Keys "hvx" ]
                in
                    Expect.equal lines [ "aaab" ]
        , test "Test with y." <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions
                            [ Keys "ia b c d", Escape, Keys "0vwy", Escape, Keys "$p" ]

                    line =
                        getLine 0 lines
                in
                    Expect.equal line "a b c da b"
        ]
