port module FileStorage.Command
    exposing
        ( loadFilesCommand
        , loadFileCommand
        , initializeStorageCommand
        , getFileStorageCommand
        , ToFileStorageMessage(..)
        , writePropertiesCommand
        , loadPropertiesCommand
        )

import Model exposing (Model)
import Properties exposing (Properties, encodeProperties)
import FileStorage.StorageMethod exposing (StorageMethod(..))
import Json.Encode as Encoder
import FileStorage.Model exposing (..)
import Mode exposing (Mode(..))


loadFilesCommand : Model -> Cmd msg
loadFilesCommand model =
    getFileStorageCommand model.properties.storageMethod GetFileList


writePropertiesCommand : Model -> ( Model, Cmd msg )
writePropertiesCommand model =
    { model | mode = Control }
        ! [ getFileStorageCommand LocalStorage <| WriteProperties model.properties
          ]


loadPropertiesCommand : Cmd msg
loadPropertiesCommand =
    getFileStorageCommand LocalStorage LoadProperties


initializeStorageCommand : StorageMethod -> Cmd msg
initializeStorageCommand storageMethod =
    getFileStorageCommand storageMethod Initialize


port toFileStorageJavaScript : Encoder.Value -> Cmd msg


type
    ToFileStorageMessage
    -- Signature is the file info and the contents
    = WriteFile File String
      -- Signature is name contents
    | WriteNewFile String String
    | LoadFile String
    | GetFileList
    | TriggerSignin
    | TriggerSignout
    | WriteProperties Properties
    | LoadProperties
    | Initialize


loadFileCommand : Model -> String -> Cmd msg
loadFileCommand model id =
    getFileStorageCommand model.properties.storageMethod <| LoadFile id


getFileStorageCommand : StorageMethod -> ToFileStorageMessage -> Cmd msg
getFileStorageCommand storageMethod msg =
    toFileStorageJavaScript <|
        case msg of
            WriteFile file contents ->
                Encoder.object
                    [ ( "type", Encoder.string "WriteFile" )
                    , ( "metadata", fileEncoder file )
                    , ( "contents", Encoder.string contents )
                    , ( "storageMethod", Encoder.string <| toString storageMethod )
                    ]

            WriteNewFile fileName contents ->
                Encoder.object
                    [ ( "type", Encoder.string "WriteFile" )
                    , ( "metadata", Encoder.object [ ( "name", Encoder.string fileName ) ] )
                    , ( "contents", Encoder.string contents )
                    , ( "storageMethod", Encoder.string <| toString storageMethod )
                    ]

            LoadFile id ->
                Encoder.object
                    [ ( "type", Encoder.string "LoadFile" )
                    , ( "id", Encoder.string id )
                    , ( "storageMethod", Encoder.string <| toString storageMethod )
                    ]

            WriteProperties props ->
                Encoder.object
                    [ ( "type", Encoder.string "WriteProperties" )
                    , ( "storageMethod", Encoder.string <| toString LocalStorage )
                    , ( "payload", encodeProperties props )
                    ]

            LoadProperties ->
                Encoder.object
                    [ ( "type", Encoder.string "LoadProperties" )
                    , ( "storageMethod", Encoder.string <| toString LocalStorage )
                    ]

            GetFileList ->
                Encoder.object
                    [ ( "type", Encoder.string "GetFileList" )
                    , ( "storageMethod", Encoder.string <| toString storageMethod )
                    ]

            TriggerSignin ->
                Encoder.object
                    [ ( "type", Encoder.string "TriggerSignin" )
                    , ( "storageMethod", Encoder.string <| toString storageMethod )
                    ]

            TriggerSignout ->
                Encoder.object
                    [ ( "type", Encoder.string "TriggerSignout" )
                    , ( "storageMethod", Encoder.string <| toString storageMethod )
                    ]

            Initialize ->
                Encoder.object
                    [ ( "type", Encoder.string "Initialize" )
                    , ( "storageMethod", Encoder.string <| toString storageMethod )
                    ]
