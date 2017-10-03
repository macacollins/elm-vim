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
                    Expect.equal mode <| Visual 5 0
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
                            [ Keys "ia b c d", Escape, Keys "0vwx" ]
                in
                    Expect.equal buffer <| InlineBuffer [ "a b" ]
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
