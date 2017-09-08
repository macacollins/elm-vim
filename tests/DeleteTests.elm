module DeleteTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Actions exposing (ActionEntry(..), newStateAfterActions)
import Array


dTests : Test
dTests =
    describe "The d key"
        [ test "one key press goes to the in progress" <|
            \_ ->
                let
                    { inProgress } =
                        newStateAfterActions [ Keys "d" ]
                in
                    Expect.equal inProgress [ 'd' ]
        , test "2 key presses removes a line" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "ia", Enter, Keys "test", Escape, Keys "kdd" ]
                in
                    Expect.equal (Array.length lines) 1
        , test "2 key presses removes the right line" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "ia", Enter, Keys "test", Escape, Keys "kdd" ]
                in
                    Expect.equal (getLine 0 lines) "test"
        ]


getLine : Int -> Array.Array String -> String
getLine index lines =
    case Array.get index lines of
        Just head ->
            head

        Nothing ->
            "Failed; no lines"


xTests : Test
xTests =
    describe "The x key"
        [ test "Delete one character" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "iaa", Escape, Keys "hx" ]

                    finalLine =
                        getLine 0 lines
                in
                    Expect.equal finalLine "a"
        , test "Doesn't switch lines" <|
            \_ ->
                let
                    { lines } =
                        newStateAfterActions [ Keys "iaa", Enter, Escape, Keys "khx" ]

                    finalLine =
                        case Array.get 0 lines of
                            Just head ->
                                head

                            Nothing ->
                                "Failed; no lines"
                in
                    Expect.equal finalLine "a"
        ]
