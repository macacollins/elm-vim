module Handlers.Navigation exposing (handleUp, handleDown, handleLeft, handleRight)

import Model exposing (Model)
import Util.ListUtils exposing (getLine)


handleUp : Model -> Model
handleUp model =
    if model.cursorY == 0 then
        model
    else if model.cursorY - 1 < model.firstLine then
        { model | cursorY = model.cursorY - 1, firstLine = model.cursorY - 1 }
    else
        { model | cursorY = model.cursorY - 1 }


handleDown : Model -> Model
handleDown model =
    if model.cursorY == List.length model.lines - 1 then
        model
    else if model.cursorY + 1 > model.firstLine + 30 then
        { model | cursorY = model.cursorY + 1, firstLine = model.cursorY - 29 }
    else
        { model | cursorY = model.cursorY + 1 }


handleLeft : Model -> Model
handleLeft model =
    let
        currentLine =
            getLine model.cursorY model.lines

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


handleRight : Model -> Model
handleRight model =
    let
        currentLine =
            getLine model.cursorY model.lines

        newCursorX =
            if model.cursorX < String.length currentLine then
                model.cursorX + 1
            else if model.cursorX == 0 then
                0
            else
                String.length currentLine
    in
        { model | cursorX = newCursorX }
