module Modes.Control exposing (controlModeUpdate)

import Model exposing (Model)
import Keyboard exposing (KeyCode)
import List exposing (..)
import Char
import Mode exposing (Mode(..))
import Handlers.DeleteCharacter exposing (..)
import Handlers.Delete exposing (..)
import Handlers.Paste exposing (handleP)
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
                    let
                        currentLine =
                            getLine cursorY lines

                        newCursorX =
                            if model.cursorX < String.length currentLine then
                                model.cursorX + 1
                            else if model.cursorX == 0 then
                                0
                            else
                                String.length currentLine
                    in
                        { model | cursorX = newCursorX }

                104 ->
                    -- h
                    let
                        currentLine =
                            getLine cursorY lines

                        newCursorX =
                            if model.cursorX == 0 then
                                0
                            else if String.length currentLine == 0 then
                                0
                            else if model.cursorX > String.length currentLine then
                                String.length currentLine - 1
                            else
                                model.cursorX - 1
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

                79 ->
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

                112 ->
                    handleP model

                _ ->
                    model
    in
        ( newModel, Cmd.none )
