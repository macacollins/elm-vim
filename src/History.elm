module History exposing (..)

import Model exposing (..)


addHistory : Model -> Model -> Model
addHistory lastModel newModel =
    { newModel | pastStates = getUpdatedHistory lastModel }


getUpdatedHistory : Model -> List State
getUpdatedHistory model =
    getState model :: model.pastStates
