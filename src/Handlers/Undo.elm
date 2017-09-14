module Handlers.Undo exposing (..)

import Model exposing (Model)


handleU : Model -> Model
handleU model =
    case List.head model.pastStates of
        Just lastState ->
            { model
                | pastStates = List.drop 1 model.pastStates
                , cursorX = lastState.cursorX
                , cursorY = lastState.cursorY
                , lines = lastState.lines
                , firstLine = lastState.firstLine
            }

        Nothing ->
            Debug.log "Can't go back any further." model
