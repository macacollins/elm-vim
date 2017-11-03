module FileStorage.Drive exposing (handleGoogleDriveWrite)

import Model exposing (Model)
import FileStorage.Model exposing (..)


handleGoogleDriveWrite : Model -> String -> ( Model, Cmd msg )
handleGoogleDriveWrite model name =
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
        { model | mode = Control } ! [ getFileStorageCommand command ]
