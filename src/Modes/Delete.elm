module Modes.Delete exposing (deleteModeUpdate)

import Model exposing (Model)
import Keyboard exposing (KeyCode)


deleteModeUpdate : Model -> KeyCode -> ( Model, Cmd msg )
deleteModeUpdate model keyCode =
    model ! []
