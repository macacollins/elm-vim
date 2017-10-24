module Delete.DeleteLines exposing (deleteLines)

import Model exposing (Model, PasteBuffer(..))
import Mode exposing (Mode(..))
import List
import Util.ListUtils exposing (..)
import Util.ModifierUtils exposing (..)
import History exposing (getUpdatedHistory)


deleteLines : Model -> Model
deleteLines model =
    let
        numberModifier =
            getNumberModifier model

        ( lines, newBuffer ) =
            removeSlice model.cursorY (model.cursorY + numberModifier) model.lines

        actualLines =
            if lines == [] then
                [ "" ]
            else
                lines

        newPastStates =
            getUpdatedHistory model

        updatedCursorY =
            if model.cursorY > List.length actualLines - 1 then
                List.length actualLines - 1
            else
                model.cursorY
    in
        { model
            | numberBuffer = []
            , lines = actualLines
            , buffer = newBuffer
            , pastStates = newPastStates
            , mode = Control
            , cursorY = updatedCursorY
        }
