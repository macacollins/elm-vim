module Modes.Control exposing (controlModeUpdate)

import Model exposing (Model)
import Keyboard exposing (KeyCode)
import Array exposing (..)
import Char
import Mode exposing (Mode(..))


controlModeUpdate : Model -> KeyCode -> ( Model, Cmd msg )
controlModeUpdate model keyCode =
    let
        trash =
            Debug.log "Pressed" keyCode

        newModel =
            case keyCode of
                108 ->
                    -- h
                    { model | cursorX = model.cursorX + 1 }

                104 ->
                    -- l
                    { model | cursorX = model.cursorX - 1 }

                106 ->
                    -- j
                    if model.cursorY == length model.lines - 1 then
                        model
                    else
                        { model | cursorY = model.cursorY + 1 }

                107 ->
                    -- k
                    if model.cursorY == 0 then
                        model
                    else
                        { model | cursorY = model.cursorY - 1 }

                105 ->
                    -- i
                    { model | mode = Insert }

                _ ->
                    model
    in
        ( newModel, Cmd.none )
