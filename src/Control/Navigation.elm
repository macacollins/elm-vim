module Control.Navigation exposing (handleUp, handleDown, handleLeft, handleRight, deleteUp, deleteDown)

import Model exposing (Model, PasteBuffer(..))
import Util.ListUtils exposing (getLine, removeSlice)
import Util.ModifierUtils exposing (..)


deleteUp : Model -> Model
deleteUp model =
    let
        numberModifier =
            getNumberModifier model

        newCursorY =
            if numberModifier > model.cursorY then
                0
            else
                model.cursorY - numberModifier
    in
        cutLines newCursorY model.cursorY model


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



-- TODO handle firstLine adjustments


cutLines : Int -> Int -> Model -> Model
cutLines start finish model =
    let
        ( newLines, maybeRemoved ) =
            removeSlice start (finish + 1) model.lines

        actualNewLines =
            if newLines == [] then
                [ "" ]
            else
                newLines

        newFirstLine =
            if start < model.firstLine then
                start
            else
                model.firstLine

        actualNewCursorY =
            if List.length newLines == 0 then
                0
            else if start < List.length newLines then
                start
            else
                List.length newLines - 1
    in
        case maybeRemoved of
            Just removed ->
                { model
                    | lines = actualNewLines
                    , buffer = LinesBuffer removed
                    , cursorX = 0
                    , cursorY = actualNewCursorY
                    , inProgress = []
                    , firstLine = newFirstLine
                }

            _ ->
                model


deleteDown : Model -> Model
deleteDown model =
    let
        numberModifier =
            getNumberModifier model

        newCursorY =
            if numberModifier + model.cursorY > List.length model.lines - 1 then
                List.length model.lines - 1
            else
                model.cursorY + numberModifier
    in
        cutLines model.cursorY newCursorY model


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
        if List.member 'd' model.inProgress then
            cutLines model.cursorY newCursorY model
        else
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
