module Handlers.Delete exposing (handleD)

import Model exposing (Model)
import List
import Util.ListUtils exposing (..)


handleD : Model -> Model
handleD model =
    let
        newInProgress =
            if List.length model.inProgress > 0 then
                []
            else
                [ 'd' ]

        ( lines, removed ) =
            if List.member 'd' model.inProgress then
                removeAtIndex model.cursorY model.lines
            else
                ( model.lines, Nothing )

        newBuffer =
            case removed of
                Just thing ->
                    thing

                Nothing ->
                    ""
    in
        { model | inProgress = newInProgress, lines = lines, buffer = newBuffer }
