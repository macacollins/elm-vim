module GotoLineTests exposing (..)

import Expect
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List


testGoto : Test
testGoto =
    describe "try to go to a line using G"
        [ test "go to a line" <|
            \_ ->
                let
                    { cursorY } =
                        newStateAfterActions <|
                            [ Keys "i" ]
                                ++ (List.repeat 500 Enter)
                                ++ [ Escape, Keys "5G" ]
                in
                    Expect.equal cursorY 4
        , test "move firstline up." <|
            \_ ->
                let
                    { firstLine } =
                        newStateAfterActions <|
                            [ Keys "i" ]
                                ++ (List.repeat 500 Enter)
                                ++ [ Escape, Keys "5G" ]
                in
                    Expect.equal firstLine 0
        , test "don't go too far" <|
            \_ ->
                let
                    { cursorY } =
                        newStateAfterActions <|
                            [ Keys "5G" ]
                in
                    Expect.equal cursorY 0
        ]


testGotoLittleG : Test
testGotoLittleG =
    describe "try to go to a line using gg"
        [ test "go to a line" <|
            \_ ->
                let
                    { cursorY } =
                        newStateAfterActions <|
                            [ Keys "i" ]
                                ++ (List.repeat 500 Enter)
                                ++ [ Escape, Keys "5gg" ]
                in
                    Expect.equal cursorY 4
        , test "move firstline up." <|
            \_ ->
                let
                    { firstLine } =
                        newStateAfterActions <|
                            [ Keys "i" ]
                                ++ (List.repeat 500 Enter)
                                ++ [ Escape, Keys "5gg" ]
                in
                    Expect.equal firstLine 0
        , test "don't go too far" <|
            \_ ->
                let
                    { cursorY } =
                        newStateAfterActions <|
                            [ Keys "5gg" ]
                in
                    Expect.equal cursorY 0
        ]
