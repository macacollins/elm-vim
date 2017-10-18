module AppendAtBeginningTests exposing (..)

import Expect
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List
import Mode exposing (Mode(..))


{- this is capital I
   Should test:
   1. empty line
   2. at end of line
   3. at start of line
-}


testAppendAtBeginningOfLine : Test
testAppendAtBeginningOfLine =
    describe "capital I" <|
        [ let
            { mode, lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "I" ]
          in
            describe "empty buffer"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "" ]
                , test "cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test "cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                ]
        , let
            { mode, lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "iasdfasdf", Escape, Keys "I" ]
          in
            describe "from end of line"
                [ test "leave lines" <|
                    \_ ->
                        Expect.equal lines [ "asdfasdf" ]
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                ]
        , let
            { lines, mode, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i12341234", Keys "1234", Escape, Keys "0I" ]
          in
            describe "from start of line"
                [ test "leave lines" <|
                    \_ ->
                        Expect.equal lines [ "123412341234" ]
                , test "mode" <|
                    \_ ->
                        Expect.equal mode Insert
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                ]
        ]
