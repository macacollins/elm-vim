module Control.NewLine exposing (handleNewLine)

import Model exposing (Model)
import List exposing (..)
import Util.ListUtils exposing (..)


handleNewLine : Model -> Model
handleNewLine model =
    let
        sliceIndex =
            (model.cursorY + 1)

        updatedLines =
            insertAtIndex sliceIndex model.lines ""

        newCursorY =
            model.cursorY + 1

        newCursorX =
            0

        newFirstLine =
            if newCursorY > model.firstLine + 30 then
                newCursorY - 30
            else
                model.firstLine
    in
        { model
            | lines = updatedLines
            , cursorY = newCursorY
            , cursorX = newCursorX
            , firstLine = newFirstLine
        }
