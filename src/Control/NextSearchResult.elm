module Control.NextSearchResult exposing (navigateToNextSearchResult)

import Model exposing (Model)
import Util.Search exposing (searchTo)


navigateToNextSearchResult : Model -> Model
navigateToNextSearchResult model =
    case searchTo model.searchString model of
        Just updatedModel ->
            updatedModel

        Nothing ->
            model
