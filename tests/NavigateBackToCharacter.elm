module NavigateBackToCharacter exposing (..)

import Expect
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List
import Mode exposing (Mode(..))
import Model exposing (Model, PasteBuffer(..))


{-
   Navigate back with F

   1. empty buffer
   2. multiple times
   3. simple case
   4. from start of line
   5. no match
-}


testNavigateBackToCharacter : Test
testNavigateBackToCharacter =
    describe "F" <|
        [ let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "Fe" ]
          in
            describe "empty  buffer"
                [ test " lines" <|
                    \_ ->
                        Expect.equal lines [ "" ]
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i123412341234", Escape, Keys "F1" ]
          in
            describe "normal case"
                [ test " lines" <|
                    \_ ->
                        Expect.equal lines [ "123412341234" ]
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 8
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i132412341234", Escape, Keys "F4F4" ]
          in
            describe "multiple times"
                [ test " lines" <|
                    \_ ->
                        Expect.equal lines [ "132412341234" ]
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 3
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i123412341234", Escape, Keys "Fe" ]
          in
            describe "search for somethign that's not on the line"
                [ test " lines" <|
                    \_ ->
                        Expect.equal lines [ "123412341234" ]
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 11
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i132412341234", Escape, Keys "0F2" ]
          in
            describe "from start of line"
                [ test " lines" <|
                    \_ ->
                        Expect.equal lines [ "132412341234" ]
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                ]
        ]
