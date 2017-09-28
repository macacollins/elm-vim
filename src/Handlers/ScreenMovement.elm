module Handlers.ScreenMovement exposing (handleCapitalH)

import Model exposing (Model)


handleCapitalH : Model -> Model
handleCapitalH model =
    { model | cursorY = model.firstLine }
