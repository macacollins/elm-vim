module Handlers.Navigation exposing (handleUp, handleDown, handleLeft, handleRight)

import Model exposing (Model)
import Util.ListUtils exposing (getLine)
import Util.ModifierUtils exposing (..)


handleUp : Model -> Model
handleUp model =
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
            | inProgress = []
            , cursorY = newCursorY
            , firstLine = newFirstLine
        }


handleDown : Model -> Model
handleDown model =
    let
        numberModifier =
            getNumberModifier model

        newCursorY =
            if numberModifier + model.cursorY > List.length model.lines - 1 then
                List.length model.lines - 1
            else
                model.cursorY + numberModifier

        newFirstLine =
            if newCursorY > model.firstLine + 30 then
                newCursorY - 30
            else
                model.firstLine
    in
        { model
            | inProgress = []
            , cursorY = newCursorY
            , firstLine = newFirstLine
        }


handleLeft : Model -> Model
handleLeft model =
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
        { model | cursorX = newCursorX, inProgress = [] }


handleRight : Model -> Model
handleRight model =
    let
        numberModifier =
            getNumberModifier model

        currentLine =
            getLine model.cursorY model.lines

        newCursorX =
            if model.cursorX + numberModifier < String.length currentLine then
                model.cursorX + numberModifier
            else
                String.length currentLine
    in
        { model | cursorX = newCursorX, inProgress = [] }
