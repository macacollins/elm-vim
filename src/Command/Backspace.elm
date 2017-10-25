module Command.Backspace exposing (backspace)

import Model exposing (Model)
import Mode exposing (Mode(..))
import Command.Util exposing (getCommandModeText)


backspace : Model -> ( Model, Cmd msg )
backspace model =
    let
        text =
            getCommandModeText model

        newMode =
            if String.length text > 1 then
                Command <| String.dropRight 1 text
            else
                Control
    in
        { model | mode = newMode } ! []
