module Control.InsertLineAboveCursor exposing (insertLineAboveCursor)

import Mode exposing (Mode(Insert))
import Model exposing (Model)
import History exposing (addHistory)
import Util.ListUtils exposing (insertAtIndex)


insertLineAboveCursor : Model -> Model
insertLineAboveCursor model =
    let
        updatedLines =
            insertAtIndex (model.cursorY) model.lines ""
    in
        addHistory model
            { model
                | mode = Insert
                , lines = updatedLines
                , cursorX = 0
            }
