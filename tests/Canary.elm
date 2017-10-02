module Canary exposing (..)

import Expect
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List


testCanary : Test
testCanary =
    describe "the canary test"
        [ test "should always succeed. If it fails, you have environment problems" <|
            \_ ->
                let
                    { cursorY } =
                        newStateAfterActions
                            [ Keys "z" ]
                in
                    Expect.equal 1 1
        ]
