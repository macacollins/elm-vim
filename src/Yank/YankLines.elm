module Yank.YankLines exposing (..)

import Model exposing (Model, PasteBuffer(..))
import List
import Util.ListUtils exposing (..)
import Util.ModifierUtils exposing (..)
import History exposing (getUpdatedHistory)
import Mode exposing (Mode(..))


yankLines : Model -> Model
yankLines model =
    let
        modifierNumber =
            getNumberModifier model

        newBuffer =
            List.drop model.cursorY model.lines
                |> List.take modifierNumber
    in
        { model
            | buffer = LinesBuffer newBuffer
            , mode = Control
        }
