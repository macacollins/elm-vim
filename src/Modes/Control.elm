module Modes.Control exposing (controlModeUpdate)

import Model exposing (Model)
import Keyboard exposing (KeyCode)
import Array exposing (..)
import Char
import Mode exposing (Mode(..))
import Handlers.DeleteCharacter exposing (..)
import Handlers.Delete exposing (..)


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
                    -- h
                    let
                        currentLine =
                            case get cursorY lines of
                                Just line ->
                                    line

                                Nothing ->
                                    ""

                        newCursorX =
                            if model.cursorX < String.length currentLine then
                                model.cursorX + 1
                            else
                                model.cursorX
                    in
                        { model | cursorX = newCursorX }

                104 ->
                    let
                        currentLine =
                            case get cursorY lines of
                                Just line ->
                                    line

                                Nothing ->
                                    ""

                        newCursorX =
                            if model.cursorX > 0 then
                                model.cursorX - 1
                            else
                                model.cursorX
                    in
                        { model | cursorX = newCursorX }

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

                100 ->
                    -- d
                    handleD model

                105 ->
                    -- i
                    { model | mode = Insert }

                120 ->
                    handleX model

                _ ->
                    model
    in
        ( newModel, Cmd.none )
