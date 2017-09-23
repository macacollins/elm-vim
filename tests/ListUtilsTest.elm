module ListUtilsTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List
import Util.ListUtils exposing (..)
import Mode exposing (Mode(..))


testLines =
    [ "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" ]


removeSliceTests : Test
removeSliceTests =
    describe "Remove slice"
        [ test "will remove only one line if you ask nicely" <|
            \_ ->
                let
                    ( result, removed ) =
                        removeSlice 2 3 testLines
                in
                    Expect.equal (List.length result) 9
        , test "Will populate the removed value with the single removed line." <|
            \_ ->
                let
                    ( result, removed ) =
                        removeSlice 2 3 testLines
                in
                    Expect.equal removed (Just [ "3" ])
        , test "Removes 3 lines" <|
            \_ ->
                let
                    ( result, removed ) =
                        removeSlice 2 5 testLines
                in
                    Expect.equal (List.length result) 7
        , test "Puts the 3 lines in the returned removed buffer" <|
            \_ ->
                let
                    ( result, removed ) =
                        removeSlice 2 5 testLines
                in
                    Expect.equal removed (Just [ "3", "4", "5" ])
        , test "if the last index is too high, it copies to the end of the array" <|
            \_ ->
                let
                    ( result, removed ) =
                        removeSlice 2 500 testLines
                in
                    Expect.equal removed (Just [ "3", "4", "5", "6", "7", "8", "9", "10" ])
        , test "if the last index is too high, it removes to the end of the array" <|
            \_ ->
                let
                    ( result, removed ) =
                        removeSlice 2 500 testLines
                in
                    Expect.equal result ([ "1", "2" ])
        ]
