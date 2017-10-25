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
            , ( ":set !relati\t", .relativeLineNumbers, False )
            , ( ":set !relativenumber", .relativeLineNumbers, False )
            , ( ":set num\t", .lineNumbers, True )
            , ( ":set number", .lineNumbers, True )
            , ( ":set !number", .lineNumbers, False )
            , ( ":set !nu\t", .lineNumbers, False )
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
