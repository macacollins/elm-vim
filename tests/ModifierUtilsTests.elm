module ModifierUtilsTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Actions exposing (ActionEntry(..), newStateAfterActions)
import List
import Util.ListUtils exposing (..)
import Util.ModifierUtils exposing (..)
import Mode exposing (Mode(..))
import Model exposing (..)


numTests : Test
numTests =
    describe "getNumberModifier tests"
        [ test "Empty returns 1." <|
            \_ ->
                Expect.equal (getNumberModifier initialModel) 1
        , test "Single character works." <|
            \_ ->
                let
                    model =
                        newStateAfterActions [ Keys "3" ]

                    result =
                        getNumberModifier model
                in
                    Expect.equal result 3
        ]
