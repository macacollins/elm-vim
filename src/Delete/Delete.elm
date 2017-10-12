module Delete.Delete exposing (handleD)

import Model exposing (Model, PasteBuffer(..))
import Mode exposing (Mode(..))
import List
import Util.ListUtils exposing (..)
import Util.ModifierUtils exposing (..)
import History exposing (getUpdatedHistory)


handleD : Model -> Model
handleD model =
    let
        numberModifier =
            getNumberModifier model

        ( lines, removed ) =
            removeSlice model.cursorY (model.cursorY + numberModifier) model.lines

        actualLines =
            if lines == [] then
                [ "" ]
            else
                lines

        ( newBuffer, newPastStates ) =
            case removed of
                Just thing ->
                    ( LinesBuffer thing, getUpdatedHistory model )

                Nothing ->
                    ( LinesBuffer [ "" ], model.pastStates )

        updatedCursorY =
            if model.cursorY > List.length actualLines - 1 then
                List.length actualLines - 1
            else
                model.cursorY
    in
        { model
            | inProgress = []
            , lines = actualLines
            , buffer = newBuffer
            , pastStates = newPastStates
            , mode = Control
            , cursorY = updatedCursorY
        }
