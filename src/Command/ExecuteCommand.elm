module Command.ExecuteCommand exposing (executeCommand, commandDict, setShowFiles)

import Drive exposing (ToDriveMessage(..), newFile, getDriveCommand, FileStatus(..), loadFilesCommand)
import Command.WriteToLocalStorage exposing (writeToLocalStorage, writeProperties)
import Dict exposing (Dict)
import Mode exposing (Mode(..))
import Model exposing (Model)
import Properties exposing (Properties)
import Theme exposing (Theme(..))
import Storage exposing (StorageMethod(..))


executeCommand : Model -> String -> ( Model, Cmd msg )
executeCommand model commandName =
    case Dict.get commandName commandDict of
        Just command ->
            command model

        Nothing ->
            if commandName == ":w" then
                delegateWrite model <| getCurrentFileNameOrUntitled model
            else if String.startsWith ":w " commandName then
                delegateWrite model (String.dropLeft 3 commandName)
            else if String.startsWith ":e " commandName then
                handleLoad model (String.dropLeft 3 commandName)
            else
                { model | mode = Control } ! []


getCurrentFileNameOrUntitled : Model -> String
getCurrentFileNameOrUntitled model =
    case model.driveState.currentFileStatus of
        New ->
            "Untitled"

        NewError _ ->
            "Untitled"

        Saved metadata ->
            metadata.name

        UnsavedChanges metadata ->
            metadata.name

        SavedError metadata _ ->
            metadata.name


delegateWrite : Model -> String -> ( Model, Cmd msg )
delegateWrite model name =
    if model.properties.storageMethod == GoogleDrive then
        handleGoogleDriveWrite model name
    else
        -- TODO have smarter writeLocalStorage
        writeToLocalStorage model


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


handleGoogleDriveWrite : Model -> String -> ( Model, Cmd msg )
handleGoogleDriveWrite model name =
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
        --
        -- TODO replace :set ! with :set no
        --
        |> Dict.insert ":set testsFromMacros" (setTestsFromMacros True)
        |> Dict.insert ":set !testsFromMacros" (setTestsFromMacros False)
        --
        -- These are the basic number commands from vim
        |> Dict.insert ":set number" (setLineNumber True)
        |> Dict.insert ":set !number" (setLineNumber False)
        |> Dict.insert ":set relativenumber" (setRelativeLineNumber True)
        |> Dict.insert ":set !relativenumber" (setRelativeLineNumber False)
        --
        -- set storage mode
        -- TODO if we get more stuff, consider :set storage=drive
        |> Dict.insert ":set drive" (setStorageMethod GoogleDrive)
        |> Dict.insert ":set nodrive" (setStorageMethod LocalStorage)
        |> Dict.insert ":save properties" writeProperties
        --
        -- Google Drive specific commands
        -- TODO figure out if these should become more generic
        |> Dict.insert ":files" setShowFiles
        |> Dict.insert ":drive signin" (runDriveCommand TriggerSignin)
        |> Dict.insert ":drive signout" (runDriveCommand TriggerSignout)
        |> Dict.insert ":drive files" (runDriveCommand GetFileList)
        --
        -- TODO Consider :set theme=night or similar
        |> Dict.insert ":night" (setTheme Night)
        |> Dict.insert ":day" (setTheme Day)


write : Model -> ( Model, Cmd msg )
write model =
    case model.properties.storageMethod of
        LocalStorage ->
            writeToLocalStorage model

        GoogleDrive ->
            writeToGoogleDrive model


writeToGoogleDrive : Model -> ( Model, Cmd msg )
writeToGoogleDrive model =
    let
        name =
            case model.driveState.currentFileStatus of
                New ->
                    "Untitled"

                NewError _ ->
                    "Untitled"

                Saved file ->
                    file.name

                SavedError file _ ->
                    file.name

                UnsavedChanges file ->
                    file.name
    in
        handleGoogleDriveWrite model name


runDriveCommand : ToDriveMessage -> Model -> ( Model, Cmd msg )
runDriveCommand message model =
    { model | mode = Control } ! [ getDriveCommand message ]



{- TODO see if there's a more dynamic way to do this -}


setShowFiles : Model -> ( Model, Cmd msg )
setShowFiles model =
    { model | mode = FileSearch "" 0 } ! [ loadFilesCommand ]


setStorageMethod : StorageMethod -> Model -> ( Model, Cmd msg )
setStorageMethod newStorageMethod model =
    propertiesUpdate (\properties -> { properties | storageMethod = newStorageMethod }) model


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
