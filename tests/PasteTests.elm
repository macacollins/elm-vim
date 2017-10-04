module PasteTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import Util.ListUtils exposing (..)
import Model exposing (PasteBuffer(..))


-- TODO also handle capital P. It's already crossed off the list :D


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
        ]
