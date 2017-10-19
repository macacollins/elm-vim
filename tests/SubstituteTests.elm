module SubstituteTests exposing (..)

import Expect
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List
import Mode exposing (Mode(..))
import Model exposing (Model, PasteBuffer(..))


{-

   Substitute with s. This should be

   1. empty buffer
   2. single character
   3. multiple characters in line
   4. multiple characters past end of line

-}


substituteTests : Test
substituteTests =
    describe "s" <|
        [ let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "s" ]
          in
            describe "empty buffer"
                [ test " lines" <|
                    \_ ->
                        Expect.equal lines [ "" ]
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| LinesBuffer []
                , test " cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test " cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i123412341234", Escape, Keys "s" ]
          in
            describe "s at end of line"
                [ test " lines" <|
                    \_ ->
                        Expect.equal lines [ "12341234123" ]
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "4" ]
                , test " cursorX" <|
                    \_ ->
                        Expect.equal cursorX 11
                , test " cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i123412341234", Escape, Keys "hhhhhhhh4s" ]
          in
            describe "4s in middle"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "12341234" ]
                , test "buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "4123" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 3
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , let
            { lines, mode, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i123412341234", Escape, Keys "hhh1000s" ]
          in
            describe "too high of a number"
                [ test "changes lines" <|
                    \_ ->
                        Expect.equal lines [ "12341234" ]
                , test "copies into buffer" <|
                    \_ ->
                        Expect.equal buffer <| InlineBuffer [ "1234" ]
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 8
                , test "moves cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        ]
