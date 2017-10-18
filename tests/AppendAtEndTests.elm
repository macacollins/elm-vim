module AppendAtEndTests exposing (..)

import Expect
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List
import Mode exposing (Mode(..))


appendAtEndTests : Test
appendAtEndTests =
    describe "Append at end" <|
        [ let
            { mode, lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "A" ]
          in
            describe "empty buffer"
                [ test "lines" <|
                    \_ ->
                        Expect.equal lines [ "" ]
                , test " mode" <|
                    \_ ->
                        Expect.equal mode Insert
                , test " cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                , test " cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "A1234" ]
          in
            describe "insert from end"
                [ test "changes lines" <|
                    \_ ->
                        Expect.equal lines [ "123412341234" ]
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 12
                , test "moves cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i12341234", Escape, Keys "0A1234" ]
          in
            describe "insert from start"
                [ test "changes lines" <|
                    \_ ->
                        Expect.equal lines [ "123412341234" ]
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 12
                , test "moves cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                ]
        ]
