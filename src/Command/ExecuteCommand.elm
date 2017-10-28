module Command.ExecuteCommand exposing (executeCommand, commandDict)

import Command.WriteToLocalStorage exposing (writeToLocalStorage)
import Dict exposing (Dict)
import Mode exposing (Mode(..))
import Model exposing (Model)
import Properties exposing (Properties)
import Theme exposing (Theme(..))


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
        |> Dict.insert ":set number" (setLineNumber True)
        |> Dict.insert ":set !number" (setLineNumber False)
        |> Dict.insert ":set relativenumber" (setRelativeLineNumber True)
        |> Dict.insert ":set !relativenumber" (setRelativeLineNumber False)
        -- TODO figure out if I want to do it this way
        |> Dict.insert ":night" (setTheme Night)
        |> Dict.insert ":day" (setTheme Day)



{- TODO see if there's a more dynamic way to do this -}


setTestsFromMacros : Bool -> Model -> ( Model, Cmd msg )
setTestsFromMacros newState model =
    propertiesUpdate (\properties -> { properties | testsFromMacros = newState }) model


setTheme : Theme -> Model -> ( Model, Cmd msg )
setTheme newTheme model =
    propertiesUpdate (\properties -> { properties | theme = newTheme }) model


setLineNumber : Bool -> Model -> ( Model, Cmd msg )
setLineNumber newState model =
    propertiesUpdate (\properties -> { properties | lineNumbers = newState }) model


setRelativeLineNumber : Bool -> Model -> ( Model, Cmd msg )
setRelativeLineNumber newState model =
    propertiesUpdate (\properties -> { properties | relativeLineNumbers = newState }) model


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
