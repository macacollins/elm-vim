module Command.Util exposing (getCommandModeText)

import Mode exposing (Mode(..))
import Model exposing (Model)


getCommandModeText : Model -> String
getCommandModeText model =
    case model.mode of
        Command (_ as innerText) ->
            innerText

        _ ->
            Debug.log "Somehow we weren't in command mode in commandModeUpdate" ":"
