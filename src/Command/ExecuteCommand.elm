module Command.ExecuteCommand exposing (executeCommand, commandDict)

import Command.WriteToLocalStorage exposing (writeToLocalStorage)
import Dict exposing (Dict)
import Mode exposing (Mode(..))
import Model exposing (Model)
import Properties exposing (Properties)


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
        |> Dict.insert ":set testsFromMacros" (setTestsFromMacros True)
        |> Dict.insert ":set !testsFromMacros" (setTestsFromMacros False)


setTestsFromMacros : Bool -> Model -> ( Model, Cmd msg )
setTestsFromMacros newState model =
    propertiesUpdate (\properties -> { properties | testsFromMacros = newState }) model


propertiesUpdate : (Properties -> Properties) -> Model -> ( Model, Cmd msg )
propertiesUpdate update model =
    let
        updatedProps =
            update model.properties
    in
        { model
            | properties = updatedProps
            , mode = Control
        }
            ! []
