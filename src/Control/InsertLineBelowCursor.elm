module Control.InsertLineBelowCursor exposing (insertLineBelowCursor)

import Mode exposing (Mode(Insert))
import Model exposing (Model)
import History exposing (addHistory)
import Util.ListUtils exposing (insertAtIndex)


insertLineBelowCursor : Model -> Model
insertLineBelowCursor model =
    let
        newCursorY =
            model.cursorY + 1

        updatedLines =
            insertAtIndex (model.cursorY + 1) model.lines ""

        updatedFirstLine =
            if newCursorY >= model.firstLine + model.linesShown then
                newCursorY - model.linesShown + 1
            else
                model.firstLine
    in
        addHistory model
            { model
                | mode = Insert
                , cursorY = newCursorY
                , cursorX = 0
                , lines = updatedLines
                , firstLine = updatedFirstLine
            }


cursorOnLastLine : Model -> Bool
cursorOnLastLine model =
    Debug.log "output"
        (model.cursorY
            == model.firstLine
            + 1
            + model.linesShown
        )
