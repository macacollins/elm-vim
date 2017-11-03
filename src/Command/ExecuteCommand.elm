module Command.ExecuteCommand exposing (executeCommand, commandDict, setShowFiles)

import FileStorage.Command exposing (..)
import FileStorage.Model exposing (FileStatus(..))
import Dict exposing (Dict)
import Mode exposing (Mode(..))
import Model exposing (Model)
import Properties exposing (Properties)
import Theme exposing (Theme(..))
import FileStorage.StorageMethod exposing (StorageMethod(..))


executeCommand : Model -> String -> ( Model, Cmd msg )
executeCommand model commandName =
    case Dict.get commandName commandDict of
        Just command ->
            command model

        Nothing ->
            if commandName == ":w" then
                handleFileStorageWrite model <| getCurrentFileNameOrUntitled model
            else if String.startsWith ":w " commandName then
                handleFileStorageWrite model (String.dropLeft 3 commandName)
            else if String.startsWith ":e " commandName then
                handleNewFile model (String.dropLeft 3 commandName)
            else
                Debug.log "Command didn't match dict or ifs"
                    { model | mode = Control }
                    ! []


getCurrentFileNameOrUntitled : Model -> String
getCurrentFileNameOrUntitled model =
    case model.fileStorageState.currentFileStatus of
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


handleNewFile : Model -> String -> ( Model, Cmd msg )
handleNewFile model name =
    let
        currentFileStorageModel =
            model.fileStorageState

        newFileStorageModel =
            { currentFileStorageModel | currentFileStatus = New }

        updatedModel =
            { model | fileStorageState = newFileStorageModel }
    in
        handleFileStorageWrite updatedModel name


handleFileStorageWrite : Model -> String -> ( Model, Cmd msg )
handleFileStorageWrite model name =
    let
        command =
            case model.fileStorageState.currentFileStatus of
                New ->
                    -- TODO rewrite prolly
                    WriteNewFile name (String.join "\x0D\n" model.lines)

                NewError _ ->
                    WriteNewFile name (String.join "\x0D\n" model.lines)

                -- TODO skip?
                Saved metadata ->
                    WriteFile { metadata | name = name } (String.join "\x0D\n" model.lines)

                UnsavedChanges metadata ->
                    WriteFile { metadata | name = name } (String.join "\x0D\n" model.lines)

                SavedError metadata _ ->
                    WriteFile { metadata | name = name } (String.join "\x0D\n" model.lines)
    in
        { model | mode = Control } ! [ getFileStorageCommand model.properties.storageMethod command ]


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
        |> Dict.insert ":save properties" (\model -> runDriveCommand (WriteProperties model.properties) model)
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
    let
        name =
            case model.fileStorageState.currentFileStatus of
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
        handleFileStorageWrite model name


runDriveCommand : ToFileStorageMessage -> Model -> ( Model, Cmd msg )
runDriveCommand message model =
    { model | mode = Control } ! [ getFileStorageCommand model.properties.storageMethod message ]



{- TODO see if there's a more dynamic way to do this -}


setShowFiles : Model -> ( Model, Cmd msg )
setShowFiles model =
    { model | mode = FileSearch "" 0 } ! [ loadFilesCommand model ]


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


setStorageMethod : StorageMethod -> Model -> ( Model, Cmd msg )
setStorageMethod newStorageMethod model =
    let
        { properties } =
            model

        newProperties =
            { properties | storageMethod = newStorageMethod }

        updatedModel =
            { model
                | properties = newProperties
                , mode = Control
            }
    in
        runDriveCommand Initialize updatedModel


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
