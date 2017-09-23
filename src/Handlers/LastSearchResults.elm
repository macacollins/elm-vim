module Handlers.LastSearchResults exposing (handleCapitalN)

import Model exposing (Model)
import Util.Search exposing (searchBackwards)


handleCapitalN : Model -> Model
handleCapitalN model =
    case searchBackwards model.searchString model of
        Just updatedModel ->
            updatedModel

        Nothing ->
            model
