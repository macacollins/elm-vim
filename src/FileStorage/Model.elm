module FileStorage.Model exposing (..)

import Json.Decode as Decoder
import Json.Encode as Encoder


type alias File =
    { name : String
    , id : String
    }


type FileStatus
    = New
    | NewError String
    | Saved File
    | SavedError File String
    | UnsavedChanges File


type alias FileStorageModel =
    { files : List File
    , currentFileStatus : FileStatus
    , lastError : Maybe String

    -- TODO figure out better abstraction
    , contents : Maybe String
    }


defaultFileStorageModel : FileStorageModel
defaultFileStorageModel =
    { files = []
    , currentFileStatus = New
    , lastError = Nothing
    , contents = Nothing
    }


fileDecoder : Decoder.Decoder File
fileDecoder =
    Decoder.map2 File
        (Decoder.field "name" Decoder.string)
        (Decoder.field "id" Decoder.string)


fileListDecoder : Decoder.Decoder (List File)
fileListDecoder =
    Decoder.list fileDecoder


fileEncoder : File -> Encoder.Value
fileEncoder file =
    Encoder.object
        [ ( "name", Encoder.string file.name )
        , ( "id", Encoder.string file.id )
        ]
