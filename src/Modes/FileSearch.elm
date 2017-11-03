module Modes.FileSearch exposing (fileSearchModeUpdate)

import Model exposing (Model)
import Mode exposing (Mode(..))
import FileStorage.Command exposing (loadFileCommand)
import Char exposing (KeyCode)


-- TODO split this up?


fileSearchModeUpdate : Model -> KeyCode -> ( Model, Cmd msg )
fileSearchModeUpdate model keyCode =
    let
        ( currentSearchString, index ) =
            case model.mode of
                FileSearch searchString index ->
                    ( searchString, index )

                _ ->
                    ( "", 0 )

        char =
            Char.fromCode keyCode

        newSearchString =
            if Char.isUpper char || Char.isLower char then
                currentSearchString
                    |> String.reverse
                    |> String.cons char
                    |> String.reverse
            else if keyCode == 8 then
                currentSearchString |> String.dropRight 1
            else
                currentSearchString

        files =
            model.fileStorageState.files
                |> List.filter (\file -> String.contains (String.toLower newSearchString) (String.toLower file.name))

        newIndex =
            if keyCode == 40 then
                if index < List.length files - 1 then
                    index + 1
                else
                    List.length files - 1
            else if keyCode == 38 then
                if index > 0 then
                    index - 1
                else
                    0
            else
                index

        commands =
            case List.drop index files of
                head :: _ ->
                    [ loadFileCommand model head.id ]

                _ ->
                    []
    in
        -- TODO consider inverting this code
        if keyCode == 27 then
            { model | mode = Control } ! []
        else if keyCode == 13 then
            { model | mode = Control } ! commands
        else
            { model | mode = FileSearch newSearchString newIndex } ! []
