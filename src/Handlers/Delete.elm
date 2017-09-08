module Handlers.Delete exposing (handleD)

import Model exposing (Model)
import Array


handleD : Model -> Model
handleD model =
    let
        newInProgress =
            if List.length model.inProgress > 0 then
                []
            else
                [ 'd' ]

        lines =
            if List.member 'd' model.inProgress then
                Array.append (Array.slice 0 model.cursorY model.lines) <|
                    Array.slice (model.cursorY + 1) (Array.length model.lines) model.lines
            else
                model.lines
    in
        { model | inProgress = newInProgress, lines = lines }
