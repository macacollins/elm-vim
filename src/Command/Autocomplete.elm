module Command.Autocomplete exposing (autocompleteCommand)

import Dict
import Model exposing (Model)
import Mode exposing (Mode(..))
import Command.ExecuteCommand exposing (commandDict)
import Command.Util exposing (getCommandModeText)


autocompleteCommand : Model -> ( Model, Cmd msg )
autocompleteCommand model =
    let
        commands =
            Dict.keys commandDict

        currentText =
            getCommandModeText model

        newMode =
            case List.filter (\word -> String.startsWith currentText word) commands of
                head :: _ ->
                    Command head

                _ ->
                    Command currentText
    in
        { model | mode = newMode } ! []
