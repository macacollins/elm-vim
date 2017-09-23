module Search exposing (..)

import Mode exposing (Mode(..))
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Actions exposing (ActionEntry(..), newStateAfterActions, applyActions, getModelForString)
import List
import Util.ListUtils exposing (..)


playground =
    getModelForString "a\nbbb ccc\nddd eee ffff"


searchSmallPlayground actions =
    applyActions playground actions


testBasicInsert : Test
testBasicInsert =
    describe "Basic Inserts"
        [ test "Playground is sane" <|
            \_ ->
                let
                    { lines } =
                        playground
                in
                    Expect.equal lines [ "a", "bbb ccc", "ddd eee ffff" ]
        , test "/ instigates search mode." <|
            \_ ->
                let
                    { mode } =
                        searchSmallPlayground [ Keys "/" ]
                in
                    Expect.equal mode Search
        , test "Enter exits search mode." <|
            \_ ->
                let
                    { mode } =
                        searchSmallPlayground [ Keys "/", Enter ]
                in
                    Expect.equal mode Control
        , test "Search for b takes you to the second line" <|
            \_ ->
                let
                    { cursorY } =
                        searchSmallPlayground [ Keys "/b", Enter ]
                in
                    Expect.equal cursorY 1
        , test "Searching again clears the search buffer" <|
            \_ ->
                let
                    { searchString } =
                        searchSmallPlayground [ Keys "/aaaaa", Enter, Keys "/", Enter ]
                in
                    Expect.equal searchString ""
        , test "Escape returns to control mode" <|
            \_ ->
                let
                    { mode } =
                        searchSmallPlayground [ Keys "/aaaaa", Escape ]
                in
                    Expect.equal mode Control
        , test "Escape restores the previous search buffer" <|
            \_ ->
                let
                    { searchString } =
                        searchSmallPlayground [ Keys "/aaaaa", Enter, Keys "/bbbbb", Escape ]
                in
                    Expect.equal searchString "aaaaa"
        , test "Test that a search for a non-present character doesn't move cursorY" <|
            \_ ->
                let
                    { cursorY } =
                        searchSmallPlayground [ Keys "/z", Enter ]
                in
                    Expect.equal cursorY 0
        , test "pressing characters adds the character to the end of the buffer." <|
            \_ ->
                let
                    { searchStringBuffer } =
                        searchSmallPlayground [ Keys "/america" ]
                in
                    Expect.equal searchStringBuffer "america"
        , test "Searching for multiple characters works too" <|
            \_ ->
                let
                    { cursorY } =
                        searchSmallPlayground [ Keys "/d e", Enter ]
                in
                    Expect.equal cursorY 2
        , test "Cursor x moves too" <|
            \_ ->
                let
                    { cursorX } =
                        searchSmallPlayground [ Keys "/d e", Enter ]
                in
                    Expect.equal cursorX 2
        ]
