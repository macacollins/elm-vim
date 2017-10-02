module Handlers.Yank exposing (..)

import Model exposing (Model, PasteBuffer(..))
import List
import Util.ListUtils exposing (..)
import Util.ModifierUtils exposing (..)
import History exposing (getUpdatedHistory)


-- TODO handle normal words


handleY : Model -> Model
handleY model =
    let
        ( actuallyYank, newInProgress ) =
            if List.member 'y' model.inProgress then
                ( True, [] )
            else
                ( False, 'y' :: model.inProgress )

        modifierNumber =
            getNumberModifier model

        newBuffer =
            List.drop model.cursorY model.lines
                |> List.take modifierNumber
    in
        if actuallyYank then
            { model
                | buffer = LinesBuffer newBuffer
                , inProgress = newInProgress
            }
        else
            { model | inProgress = newInProgress }
