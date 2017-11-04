module PropertiesTests exposing (..)

import Expect
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List
import Mode exposing (Mode(..))
import Model exposing (Model, PasteBuffer(..))
import Properties exposing (Properties)


testProperties : Test
testProperties =
    describe "tests" <|
        List.map testCommandToProps
            [ ( ":set relati\t", .relativeLineNumbers, True )
            , ( ":set relativenumber", .relativeLineNumbers, True )
            , ( ":set norelati\t", .relativeLineNumbers, False )
            , ( ":set norelativenumber", .relativeLineNumbers, False )
            , ( ":set num\t", .lineNumbers, True )
            , ( ":set number", .lineNumbers, True )
            , ( ":set nonumber", .lineNumbers, False )
            , ( ":set nonu\t", .lineNumbers, False )
            ]


testCommandToProps : ( String, Properties -> a, a ) -> Test
testCommandToProps ( command, propertyGetter, expectedValue ) =
    let
        { properties } =
            newStateAfterActions [ Keys command, Enter ]
    in
        test (command ++ " " ++ (toString propertyGetter) ++ " leads to " ++ toString expectedValue) <|
            \_ ->
                Expect.equal (propertyGetter properties) expectedValue


testEscapeGetsToCommandMode : Test
testEscapeGetsToCommandMode =
    let
        { mode } =
            newStateAfterActions [ Keys ":set sxzxaszxs\t", Escape ]
    in
        test "Escape returns to Control mode" <|
            \_ ->
                Expect.equal mode Control


testInvalidSequence : Test
testInvalidSequence =
    let
        { mode } =
            newStateAfterActions [ Keys ":set sxzxaszxs\t", Enter ]
    in
        test "Goes back to control mode with an invalid sequence" <|
            \_ ->
                Expect.equal mode Control


testBackspaceALotOfTimes : Test
testBackspaceALotOfTimes =
    let
        { mode } =
            newStateAfterActions [ Keys ":s", Backspace, Backspace ]
    in
        test "goes back to control mode" <|
            \_ ->
                Expect.equal mode Control


testBackspace : Test
testBackspace =
    let
        { mode } =
            newStateAfterActions [ Keys ":set s", Backspace ]
    in
        test "removes character from mode" <|
            \_ ->
                Expect.equal mode <| Command ":set "
