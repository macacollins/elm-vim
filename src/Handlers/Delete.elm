module Handlers.Delete exposing (handleD)

import Model exposing (Model)
import List
import Util.ListUtils exposing (..)
import History exposing (getUpdatedHistory)
import Util.ModifierUtils exposing (..)


handleD : Model -> Model
handleD model =
    let
        newInProgress =
            if List.member 'd' model.inProgress then
                []
            else
                'd' :: model.inProgress

        numberModifier =
            getNumberModifier model

        ( lines, removed ) =
            if List.member 'd' model.inProgress then
                removeSlice model.cursorY (model.cursorY + numberModifier) model.lines
            else
                ( model.lines, Nothing )

        actualLines =
            if lines == [] then
                [ "" ]
            else
                lines

        ( newBuffer, newPastStates ) =
            case removed of
                Just thing ->
                    ( thing, getUpdatedHistory model )

                Nothing ->
                    ( [ "" ], model.pastStates )
    in
        { model
            | inProgress = newInProgress
            , lines = actualLines
            , buffer = newBuffer
            , pastStates = newPastStates
        }
