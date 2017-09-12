module Modes.Control exposing (controlModeUpdate)

import Model exposing (Model)
import Keyboard exposing (KeyCode)
import List exposing (..)
import Char
import Mode exposing (Mode(..))
import Handlers.DeleteCharacter exposing (..)
import Handlers.Delete exposing (..)
import Handlers.Paste exposing (handleP)
import Handlers.Navigation exposing (..)
import Handlers.PreviousWord exposing (..)
import Handlers.NextWord exposing (..)
import Util.ListUtils exposing (..)


controlModeUpdate : Model -> KeyCode -> ( Model, Cmd msg )
controlModeUpdate model keyCode =
    let
        trash =
            Debug.log "Pressed" keyCode

        { lines, cursorX, cursorY } =
            model

        newModel =
            case keyCode of
                108 ->
                    -- l
                    handleRight model

                104 ->
                    -- h
                    handleLeft model

                106 ->
                    -- j
                    handleDown model

                107 ->
                    -- k
                    handleUp model

                100 ->
                    -- d
                    handleD model

                105 ->
                    -- i
                    { model | mode = Insert }

                120 ->
                    handleX model

                79 ->
                    -- O
                    let
                        updatedLines =
                            insertAtIndex (model.cursorY) lines ""
                    in
                        { model
                            | mode = Insert
                            , lines = updatedLines
                            , cursorX = 0
                        }

                111 ->
                    -- o
                    let
                        newCursorY =
                            model.cursorY + 1

                        updatedLines =
                            insertAtIndex (model.cursorY + 1) lines ""
                    in
                        { model
                            | mode = Insert
                            , cursorY = newCursorY
                            , cursorX = 0
                            , lines = updatedLines
                        }

                119 ->
                    handleW model

                112 ->
                    handleP model

                98 ->
                    handleB model

                _ ->
                    model
    in
        ( newModel, Cmd.none )
