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



{-
   Deletion

   empty buffer
   normal case
   start of line
   no match
   multiple

-}


deleteBackwardsToCharacterTests : Test
deleteBackwardsToCharacterTests =
    describe "dF" <|
        [ let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "dFe" ]
          in
            describe "empty buffer"
                [ test "changes lines" <|
                    \_ ->
                        Expect.equal lines [ "" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer []
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i123412341234", Escape, Keys "dF4" ]
          in
            describe "normal case"
                [ test "changes lines" <|
                    \_ ->
                        Expect.equal lines [ "12341234" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "4123" ]
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 7
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "0dF3" ]
          in
            describe "from start of line"
                [ test "changes lines" <|
                    \_ ->
                        Expect.equal lines [ "12341234" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer []
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i123412341234", Escape, Keys "dF5" ]
          in
            describe "no match"
                [ test "changes lines" <|
                    \_ ->
                        Expect.equal lines [ "123412341234" ]
                , test "leaves buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer []
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 11
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i123412341234", Escape, Keys "dF3dF3" ]
          in
            describe "delete multiple times"
                [ test "changes lines" <|
                    \_ ->
                        Expect.equal lines [ "1234124" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "3412" ]
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 6
                ]
        ]


yank : Test
yank =
    describe "yF" <|
        [ let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "yFe" ]
          in
            describe "empty buffer"
                [ test "changes lines" <|
                    \_ ->
                        Expect.equal lines [ "" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer []
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i123412341234", Escape, Keys "yF4" ]
          in
            describe "normal case"
                [ test "changes lines" <|
                    \_ ->
                        Expect.equal lines [ "123412341234" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "4123" ]
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 7
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "0yF3" ]
          in
            describe "from start of line"
                [ test "changes lines" <|
                    \_ ->
                        Expect.equal lines [ "12341234" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer []
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i123412341234", Escape, Keys "yF5" ]
          in
            describe "no match"
                [ test "changes lines" <|
                    \_ ->
                        Expect.equal lines [ "123412341234" ]
                , test "leaves buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer []
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 11
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i123412341234", Escape, Keys "yF3yF3" ]
          in
            describe "multiple"
                [ test "changes lines" <|
                    \_ ->
                        Expect.equal lines [ "123412341234" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "3412" ]
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 6
                ]
        ]
