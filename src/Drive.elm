port module Drive exposing (..)

import Json.Decode as Decoder
import Json.Encode as Encoder


port toDriveJavaScript : Encoder.Value -> Cmd msg


port fromDriveJavaScript : (Decoder.Value -> msg) -> Sub msg


type alias File =
    { name : String
    , id : Maybe String
    }


type alias DriveState =
    { files : List File
    , currentFileStatus : FileStatus
    , lastError : Maybe String
    , contents : Maybe String
    }


newFile : String -> File
newFile name =
    File name Nothing


defaultDriveState : DriveState
defaultDriveState =
    { files = []
    , currentFileStatus = New
    , lastError = Nothing
    , contents = Nothing
    }


metadataDecoder : Decoder.Decoder File
metadataDecoder =
    Decoder.map2 File
        (Decoder.field "title" Decoder.string)
        (Decoder.field "id" (Decoder.nullable Decoder.string))


fileDecoder : Decoder.Decoder File
fileDecoder =
    Decoder.map2 File
        (Decoder.field "name" Decoder.string)
        (Decoder.field "id" (Decoder.nullable Decoder.string))


fileListDecoder : Decoder.Decoder (List File)
fileListDecoder =
    Decoder.list fileDecoder


fileEncoder : File -> Encoder.Value
fileEncoder file =
    case file.id of
        Just id ->
            Encoder.object
                [ ( "name", Encoder.string file.name )
                , ( "id", Encoder.string id )
                ]

        Nothing ->
            Encoder.object
                [ ( "name", Encoder.string file.name )
                ]


type FileStatus
    = New
    | NewError String
    | Saved File
    | SavedError File String
    | UnsavedChanges File


type FromDriveMessage
    = FileList
    | SaveSuccessful File
    | SaveError String


type ToDriveMessage
    = WriteFile File String
    | LoadFile String
    | GetFileList
    | TriggerSignin
    | TriggerSignout


loadFilesCommand : Cmd msg
loadFilesCommand =
    getDriveCommand GetFileList


loadFileCommand : Maybe String -> Cmd msg
loadFileCommand id =
    case id of
        Just actualID ->
            getDriveCommand <| LoadFile actualID

        Nothing ->
            Cmd.none


getDriveCommand : ToDriveMessage -> Cmd msg
getDriveCommand msg =
    toDriveJavaScript <|
        case msg of
            WriteFile metadata contents ->
                Encoder.object
                    [ ( "type", Encoder.string "WriteFile" )
                    , ( "metadata", fileEncoder metadata )
                    , ( "contents", Encoder.string contents )
                    ]

            LoadFile id ->
                Encoder.object
                    [ ( "type", Encoder.string "LoadFile" )
                    , ( "id", Encoder.string id )
                    ]

            GetFileList ->
                Encoder.object
                    [ ( "type", Encoder.string "GetFileList" )
                    ]

            TriggerSignin ->
                Encoder.object
                    [ ( "type", Encoder.string "TriggerSignin" )
                    ]

            TriggerSignout ->
                Encoder.object
                    [ ( "type", Encoder.string "TriggerSignout" )
                    ]


updateDriveModel : Decoder.Value -> DriveState -> DriveState
updateDriveModel incomingMessage currentState =
    case Decoder.decodeValue (Decoder.field "type" Decoder.string) incomingMessage of
        Ok msg ->
            case msg of
                "FileList" ->
                    case Decoder.decodeValue (Decoder.field "files" fileListDecoder) incomingMessage of
                        Ok value ->
                            { currentState | files = value }

                        Err err ->
                            Debug.log "Error:"
                                { currentState | lastError = Just err }

                "FileLoaded" ->
                    case Decoder.decodeValue (Decoder.field "contents" Decoder.string) incomingMessage of
                        Ok contents ->
                            case Decoder.decodeValue (Decoder.field "metadata" fileDecoder) incomingMessage of
                                Ok metadata ->
                                    { currentState
                                        | currentFileStatus = Saved metadata
                                        , contents = Just contents
                                    }

                                Err err ->
                                    Debug.log "error during metadata decoding in fileloaded" <|
                                        { currentState | lastError = Just err }

                        Err err ->
                            Debug.log "Error:"
                                { currentState | lastError = Just err }

                "SaveSuccessful" ->
                    case Decoder.decodeValue (Decoder.field "metadata" metadataDecoder) incomingMessage of
                        Ok value ->
                            { currentState | currentFileStatus = Saved value }

                        Err err ->
                            Debug.log "Error:"
                                { currentState | lastError = Just err }

                "SaveError" ->
                    case Decoder.decodeValue (Decoder.field "error" Decoder.string) incomingMessage of
                        Ok value ->
                            case currentState.currentFileStatus of
                                Saved file ->
                                    { currentState | currentFileStatus = SavedError file value }

                                SavedError file _ ->
                                    { currentState | currentFileStatus = SavedError file value }

                                UnsavedChanges file ->
                                    { currentState | currentFileStatus = SavedError file value }

                                NewError _ ->
                                    { currentState | currentFileStatus = NewError value }

                                New ->
                                    { currentState | currentFileStatus = NewError value }

                        Err err ->
                            Debug.log "Error:"
                                { currentState | lastError = Just err }

                _ ->
                    Debug.log ("Nothingn found for " ++ (toString msg))
                        currentState

        Err err ->
            { currentState | lastError = Just err }
