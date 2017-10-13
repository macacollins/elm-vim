module Control.LastSearchResults exposing (navigateToLastSearchResult)

import Model exposing (Model)
import Util.Search exposing (searchBackwards)


navigateToLastSearchResult : Model -> Model
navigateToLastSearchResult model =
    case searchBackwards model.searchString model of
        Just updatedModel ->
            updatedModel

        Nothing ->
            model
