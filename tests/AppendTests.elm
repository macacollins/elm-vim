module AppendTests exposing (..)

import Expect
import Test exposing (..)
import Macro.Actions exposing (newStateAfterActions)
import Macro.ActionEntry exposing (ActionEntry(..))
import List
import Mode exposing (Mode(..))


appendTests : Test
appendTests =
    describe "a key" <|
        [ let
            { mode, lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "a" ]
          in
            describe "in empty buffer/line"
                [ test "changes lines" <|
                    \_ ->
                        Expect.equal lines [ "" ]
                , test "go to insert mode" <|
                    \_ ->
                        Expect.equal mode Insert
                , test "leaves cursorY" <|
                    \_ ->
                        Expect.equal cursorY 0
                , test "leaves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 0
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i1234", Escape, Keys "hhha1234" ]
          in
            describe "from start"
                [ test "changes lines" <|
                    \_ ->
                        Expect.equal lines [ "11234234" ]
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 5
                ]
        , let
            { lines, cursorX, buffer, cursorY } =
                newStateAfterActions [ Keys "i1234", Escape, Keys "a1234" ]
          in
            describe "from end"
                [ test "changes lines" <|
                    \_ ->
                        Expect.equal lines [ "12341234" ]
                , test "moves cursorX" <|
                    \_ ->
                        Expect.equal cursorX 8
                ]
        ]
