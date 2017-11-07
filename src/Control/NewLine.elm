module Control.NewLine exposing (handleNewLine)

import Model exposing (Model)
import List exposing (..)
import Util.ListUtils exposing (..)


handleNewLine : Model -> Model
handleNewLine model =
    let
        sliceIndex =
            (model.cursorY + 1)

        currentLine =
            getLine model.cursorY model.lines

        textToKeepOnLine =
            String.left model.cursorX currentLine

        textToCarryOver =
            String.dropLeft model.cursorX currentLine

        insertedLines =
            insertAtIndex sliceIndex updatedLines textToCarryOver

        updatedLines =
            mutateAtIndex model.cursorY model.lines (\_ -> textToKeepOnLine)

        newCursorY =
            model.cursorY + 1

        newCursorX =
            0

        newFirstLine =
            if newCursorY > model.firstLine + model.linesShown then
                newCursorY - model.linesShown
            else if newCursorY == model.firstLine + model.linesShown then
                model.firstLine + 1
            else
                model.firstLine
    in
        { model
            | lines = insertedLines
            , cursorY = newCursorY
            , cursorX = newCursorX
            , firstLine = newFirstLine
        }
