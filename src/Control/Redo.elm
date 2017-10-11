module Control.Redo exposing (..)

import Model exposing (Model)
import History exposing (..)


handleR : Model -> Model
handleR model =
    case List.head model.futureStates of
        Just futureState ->
            { model
                | futureStates = List.drop 1 model.futureStates
                , cursorX = futureState.cursorX
                , cursorY = futureState.cursorY
                , lines = futureState.lines
                , firstLine = futureState.firstLine
                , pastStates = getUpdatedHistory model
            }

        Nothing ->
            Debug.log "Can't go back any further." model
