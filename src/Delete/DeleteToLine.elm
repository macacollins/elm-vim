module Delete.DeleteToLine exposing (deleteToLine)

import Model exposing (Model)
import Util.ModifierUtils exposing (getNumberModifier, hasNumberModifier)
import Util.ListUtils exposing (..)
import Mode exposing (Mode(Control, Delete))


deleteToLine : Model -> Model
deleteToLine model =
    let
        numberModifier =
            if hasNumberModifier model then
                getNumberModifier model
            else
                0

        ( lowNumber, highNumber ) =
            if model.cursorY < numberModifier then
                ( model.cursorY, numberModifier )
            else
                ( numberModifier, model.cursorY )

        ( updatedLines, newBuffer ) =
            removeSlice (lowNumber - 1) (highNumber + 1) model.lines

        newCursorY =
            if lowNumber < List.length updatedLines then
                lowNumber
            else
                List.length updatedLines - 1
    in
        { model
            | lines = updatedLines
            , cursorX = 0
            , cursorY = newCursorY
            , buffer = newBuffer
            , mode = Control
            , inProgress = []
        }
