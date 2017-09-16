module Handlers.Delete exposing (handleD)

import Model exposing (Model)
import List
import Util.ListUtils exposing (..)
import History exposing (getUpdatedHistory)


handleD : Model -> Model
handleD model =
    let
        newInProgress =
            if List.length model.inProgress > 0 then
                []
            else
                [ 'd' ]

        ( lines, removed ) =
            -- TODO look for modifier ints in the inProgress array
            -- it will look something like String.toInt <| List.join "" <| List.filter (\c -> List.member c ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9' ]) model.inProgress
            if List.member 'd' model.inProgress then
                removeAtIndex model.cursorY model.lines
            else
                ( model.lines, Nothing )

        ( newBuffer, newPastStates ) =
            case removed of
                Just thing ->
                    ( thing, getUpdatedHistory model )

                Nothing ->
                    ( "", model.pastStates )
    in
        { model
            | inProgress = newInProgress
            , lines = lines
            , buffer = newBuffer
            , pastStates = newPastStates
        }
