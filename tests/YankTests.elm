module YankTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List
import Util.ListUtils exposing (..)
import Mode exposing (Mode(..))


yankTests : Test
yankTests =
    describe "Yank it"
        [ test "Basic yankin'" <|
            \_ ->
                let
                    { buffer } =
                        newStateAfterActions [ Keys "ia", Escape, Keys "yy" ]
                in
                    Expect.equal buffer [ "a" ]
        , test "Yank 2" <|
            \_ ->
                let
                    { buffer } =
                        newStateAfterActions [ Keys "i1", Enter, Keys "2", Enter, Keys "3", Escape, Keys "gg2yy" ]
                in
                    Expect.equal buffer [ "1", "2" ]
        , test "Yank doesn't go past the end of the buffer" <|
            \_ ->
                let
                    { buffer } =
                        newStateAfterActions [ Keys "i1", Enter, Keys "2", Enter, Keys "3", Escape, Keys "gg200yy" ]
                in
                    Expect.equal buffer [ "1", "2", "3" ]
        ]
