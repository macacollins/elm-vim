module Modes.Command exposing (commandModeUpdate)

import Model exposing (Model)
import Char exposing (KeyCode)
import Mode exposing (Mode(..))
import Command.ExecuteCommand exposing (executeCommand)
import Command.Autocomplete exposing (autocompleteCommand)
import Command.Backspace exposing (backspace)
import Command.Util exposing (getCommandModeText)


commandModeUpdate : Model -> KeyCode -> ( Model, Cmd msg )
commandModeUpdate model keyCode =
    if keyCode == 10 || keyCode == 13 then
        case model.mode of
            Command (_ as command) ->
                executeCommand model command

            _ ->
                Debug.log "Somehow we weren't in command mode in commandModeUpdate" <|
                    model
                        ! []
    else if keyCode == 9 then
        autocompleteCommand model
    else if keyCode == 27 then
        { model | mode = Control } ! []
    else if keyCode == 8 then
        backspace model
    else
        addInput model (Char.fromCode keyCode)


addInput : Model -> Char -> ( Model, Cmd msg )
addInput model char =
    let
        text =
            getCommandModeText model

        newText =
            text
                |> String.reverse
                |> String.cons char
                |> String.reverse
    in
        { model | mode = Command newText } ! []
