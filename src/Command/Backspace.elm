module Command.Backspace exposing (backspace)

import Model exposing (Model)
import Mode exposing (Mode(..))
import Command.Util exposing (getCommandModeText)


backspace : Model -> ( Model, Cmd msg )
backspace model =
    let
        text =
            getCommandModeText model

        newText =
            if String.length text > 1 then
                String.dropRight 1 text
            else
                text
    in
        { model | mode = Command newText } ! []
