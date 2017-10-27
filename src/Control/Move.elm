module Control.Move exposing (moveUp, moveDown, moveLeft, moveRight)

import Model exposing (Model, PasteBuffer(..))
import Util.ListUtils exposing (getLine, removeSlice)
import Util.ModifierUtils exposing (..)


moveUp : Model -> Model
moveUp model =
    let
        numberModifier =
            getNumberModifier model

        newCursorY =
            if numberModifier > model.cursorY then
                0
            else
                model.cursorY - numberModifier

        newFirstLine =
            if newCursorY < model.firstLine then
                newCursorY
            else
                model.firstLine
    in
        { model
            | numberBuffer = []
            , cursorY = newCursorY
            , firstLine = newFirstLine
        }


moveDown : Model -> Model
moveDown model =
    let
        numberModifier =
            getNumberModifier model

        newCursorY =
            if numberModifier + model.cursorY > List.length model.lines - 1 then
                List.length model.lines - 1
            else
                model.cursorY + numberModifier

        newFirstLine =
            if newCursorY >= model.firstLine + model.windowHeight then
                newCursorY - model.windowHeight + 1
            else
                model.firstLine
    in
        { model
            | numberBuffer = []
            , cursorY = newCursorY
            , firstLine = newFirstLine
        }


moveLeft : Model -> Model
moveLeft model =
    let
        numberModifier =
            getNumberModifier model

        currentLine =
            getLine model.cursorY model.lines

        newCursorX =
            if model.cursorX - numberModifier < 1 then
                0
            else if String.length currentLine == 0 then
                0
            else if model.cursorX > String.length currentLine then
                String.length currentLine - numberModifier
            else
                model.cursorX - numberModifier
    in
        { model | cursorX = newCursorX, numberBuffer = [] }


moveRight : Model -> Model
moveRight model =
    let
        numberModifier =
            getNumberModifier model

        currentLine =
            getLine model.cursorY model.lines

        newCursorX =
            if model.cursorX + numberModifier < String.length currentLine - 1 then
                model.cursorX + numberModifier
            else if String.length currentLine == 0 then
                0
            else
                String.length currentLine - 1
    in
        { model | cursorX = newCursorX, numberBuffer = [] }
