module Control.Undo exposing (..)

import Model exposing (..)
import History exposing (..)


handleUndo : Model -> Model
handleUndo model =
    case List.head model.pastStates of
        Just lastState ->
            { model
                | pastStates = List.drop 1 model.pastStates
                , cursorX = lastState.cursorX
                , cursorY = lastState.cursorY
                , lines = lastState.lines
                , firstLine = lastState.firstLine
                , futureStates = getState model :: model.futureStates
            }

        Nothing ->
            Debug.log "Can't go back any further." model
