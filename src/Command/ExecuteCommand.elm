module Command.ExecuteCommand exposing (executeCommand, commandDict)

import Drive exposing (ToDriveMessage(..), newFile, getDriveCommand, FileStatus(..))
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
            if String.startsWith ":w " commandName then
                handleWrite model (String.dropLeft 3 commandName)
            else if String.startsWith ":e " commandName then
                handleLoad model (String.dropLeft 3 commandName)
            else
                { model | mode = Control } ! []


handleLoad : Model -> String -> ( Model, Cmd msg )
handleLoad model name =
    let
        fileOrEmptyList =
            model.driveState.files
                |> List.filter (\file -> String.contains name file.name)

        command =
            case fileOrEmptyList of
                head :: _ ->
                    -- TODO make this not a maybe somehow
                    case head.id of
                        Just id ->
                            [ getDriveCommand <| LoadFile id ]

                        Nothing ->
                            []

                _ ->
                    []
    in
        { model | mode = Control } ! command


handleWrite : Model -> String -> ( Model, Cmd msg )
handleWrite model name =
    let
        command =
            case model.driveState.currentFileStatus of
                New ->
                    -- TODO rewrite prolly
                    WriteFile (newFile name) (String.join "\x0D\n" model.lines)

                NewError _ ->
                    WriteFile (newFile name) (String.join "\x0D\n" model.lines)

                -- TODO skip?
                Saved metadata ->
                    WriteFile { metadata | name = name } (String.join "\x0D\n" model.lines)

                UnsavedChanges metadata ->
                    WriteFile { metadata | name = name } (String.join "\x0D\n" model.lines)

                SavedError metadata _ ->
                    WriteFile { metadata | name = name } (String.join "\x0D\n" model.lines)
    in
        { model | mode = Control } ! [ getDriveCommand command ]


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
        |> Dict.insert ":drive signin" (runDriveCommand TriggerSignin)
        |> Dict.insert ":drive signout" (runDriveCommand TriggerSignout)
        |> Dict.insert ":drive files" (runDriveCommand GetFileList)
        -- TODO figure out if I want to do it this way
        |> Dict.insert ":night" (setTheme Night)
        |> Dict.insert ":day" (setTheme Day)


runDriveCommand : ToDriveMessage -> Model -> ( Model, Cmd msg )
runDriveCommand message model =
    { model | mode = Control } ! [ getDriveCommand message ]



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
