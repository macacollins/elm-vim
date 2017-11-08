module Canary exposing (..)

import Expect
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List
import Mode exposing (Mode(..))
import Model exposing (Model, PasteBuffer(..))
import Macro.ActionEntry exposing (ActionEntry(..))


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
