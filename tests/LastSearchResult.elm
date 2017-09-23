module LastSearchResult exposing (..)

import Mode exposing (Mode(..))
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Actions exposing (ActionEntry(..), newStateAfterActions, applyActions, getModelForString)
import List


playground =
    getModelForString "a\nbbb ccc\nddd eee ffff"


searchSmallPlayground actions =
    applyActions playground actions


testLastSearchResult : Test
testLastSearchResult =
    describe "Basic next search result"
        [ test "Basic one" <|
            \_ ->
                let
                    { cursorY } =
                        searchSmallPlayground [ Keys "/b", Enter, Keys "GN" ]
                in
                    Expect.equal cursorY 1
        , test "Several in a row" <|
            \_ ->
                let
                    { cursorX } =
                        searchSmallPlayground [ Keys "/b", Enter, Keys "G$NN" ]
                in
                    Expect.equal cursorX 1
        ]
