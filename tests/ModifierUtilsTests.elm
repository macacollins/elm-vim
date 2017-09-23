module ModifierUtilsTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
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
        , test "Handle 0 consistently" <|
            \_ ->
                let
                    model =
                        newStateAfterActions [ Keys "200" ]

                    result =
                        getNumberModifier model
                in
                    Expect.equal result 200
        , test "Double characters come back in the right order" <|
            \_ ->
                let
                    model =
                        newStateAfterActions [ Keys "21" ]

                    result =
                        getNumberModifier model
                in
                    Expect.equal result 21
        ]
