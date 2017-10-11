module Modes.Yank exposing (yankModeUpdate)

import Model exposing (Model)
import Keyboard exposing (KeyCode)


yankModeUpdate : Model -> KeyCode -> ( Model, Cmd msg )
yankModeUpdate model keyCode =
    model ! []
