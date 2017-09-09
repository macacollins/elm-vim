module Handlers.Delete exposing (handleD)

import Model exposing (Model)
import Array
import Util.ArrayUtils exposing (..)


handleD : Model -> Model
handleD model =
    let
        newInProgress =
            if List.length model.inProgress > 0 then
                []
            else
                [ 'd' ]

        ( lines, _ ) =
            if List.member 'd' model.inProgress then
                removeAtIndex model.cursorY model.lines
            else
                ( model.lines, Nothing )
    in
        { model | inProgress = newInProgress, lines = lines }
