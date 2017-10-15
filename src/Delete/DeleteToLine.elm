module Delete.DeleteToLine exposing (deleteToLineDefaultStart, deleteToLineDefaultEnd)

import Model exposing (Model)
import Util.ModifierUtils exposing (getNumberModifier, hasNumberModifier)
import Util.ListUtils exposing (..)
import Mode exposing (Mode(Control, Delete))


deleteToLineDefaultEnd : Model -> Model
deleteToLineDefaultEnd model =
    let
        newCursorY =
            if model.cursorY == 0 then
                0
            else if model.cursorY == List.length model.lines - 1 then
                model.cursorY
            else
                model.cursorY + 1
    in
        deleteToLine { model | cursorY = newCursorY } (List.length model.lines - 1)


deleteToLineDefaultStart : Model -> Model
deleteToLineDefaultStart model =
    deleteToLine model 0


deleteToLine : Model -> Int -> Model
deleteToLine model defaultY =
    let
        numberModifier =
            if hasNumberModifier model then
                getNumberModifier model
            else
                defaultY

        ( lowNumber, highNumber ) =
            if model.cursorY < numberModifier then
                ( model.cursorY, numberModifier )
            else
                ( numberModifier, model.cursorY )

        ( updatedLines, newBuffer ) =
            removeSlice (lowNumber - 1) (highNumber + 1) model.lines

        numLines =
            List.length updatedLines

        finalLines =
            if updatedLines == [] then
                [ "" ]
            else
                updatedLines

        newCursorY =
            if lowNumber < List.length updatedLines then
                lowNumber
            else if numLines == 0 then
                0
            else
                numLines - 1
    in
        { model
            | lines = finalLines
            , cursorX = 0
            , cursorY = newCursorY
            , buffer = newBuffer
            , mode = Control
            , inProgress = []
        }
