module Control.NextSearchResult exposing (moveToNextSearchResult)

import Model exposing (Model)
import Util.Search exposing (searchTo)


moveToNextSearchResult : Model -> Model
moveToNextSearchResult model =
    case searchTo model.searchString model of
        Just updatedModel ->
            updatedModel

        Nothing ->
            model
