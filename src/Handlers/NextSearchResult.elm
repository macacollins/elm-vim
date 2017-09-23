module Handlers.NextSearchResult exposing (handleN)

import Model exposing (Model)
import Util.Search exposing (searchTo)


handleN : Model -> Model
handleN model =
    case searchTo model.searchString model of
        Just updatedModel ->
            updatedModel

        Nothing ->
            model
