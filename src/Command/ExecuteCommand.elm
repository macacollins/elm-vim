module Command.ExecuteCommand exposing (executeCommand)

import Model exposing (Model)
import Dict exposing (Dict)
import Command.WriteToLocalStorage exposing (writeToLocalStorage)
import Mode exposing (Mode(..))


executeCommand : Model -> String -> ( Model, Cmd msg )
executeCommand model commandName =
    case Dict.get commandName commandDict of
        Just command ->
            command model

        Nothing ->
            { model | mode = Control } ! []


commandDict : Dict String (Model -> ( Model, Cmd msg ))
commandDict =
    Dict.empty
        |> Dict.insert ":w" writeToLocalStorage
