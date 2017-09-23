module PasteTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import Util.ListUtils exposing (..)


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
        ]
