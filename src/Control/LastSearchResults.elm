module Control.LastSearchResults exposing (moveToLastSearchResult)

import Model exposing (Model)
import Util.Search exposing (searchBackwards)


moveToLastSearchResult : Model -> Model
moveToLastSearchResult model =
    case searchBackwards model.searchString model of
        Just updatedModel ->
            updatedModel

        Nothing ->
            model
