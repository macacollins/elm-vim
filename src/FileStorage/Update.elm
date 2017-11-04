module FileStorage.Update exposing (..)

import Json.Decode as Decoder
import Json.Encode as Encoder
import Properties exposing (Properties, propertiesDecoder)
import Command.ExecuteCommand exposing (setShowFiles)
import FileStorage.Command exposing (loadPropertiesCommand, initializeStorageCommand)
import FileStorage.Model exposing (..)
import Util.ListUtils exposing (stringToLines)
import Model exposing (Model)
import View.Util exposing (getActualScreenWidth, getNumberOfLinesOnScreen)


updateFileStorageModel : Model -> Decoder.Value -> ( Model, Cmd msg )
updateFileStorageModel model value =
    updateLinesShown <|
        let
            newProperties =
                updateProperties value model.properties

            newDriveModel =
                innerUpdate value model.fileStorageModel

            newContents =
                case newDriveModel.contents of
                    Just string ->
                        stringToLines string

                    Nothing ->
                        model.lines

            ( newX, newY ) =
                if model.lines == newContents then
                    ( model.cursorX, model.cursorY )
                else
                    ( 0, 0 )

            modelWithoutContents =
                { newDriveModel | contents = Nothing }

            updateMostFields =
                { model
                    | lines = newContents
                    , cursorX = newX
                    , cursorY = newY
                    , fileStorageModel = modelWithoutContents
                    , properties = newProperties
                }
        in
            updateMode value updateMostFields



-- TODO reconsider these functions. Lots of boilerplate


updateMode : Decoder.Value -> Model -> ( Model, Cmd msg )
updateMode incomingMessage model =
    case Decoder.decodeValue (Decoder.field "type" Decoder.string) incomingMessage of
        Ok msg ->
            case msg of
                "TriggerFileSearch" ->
                    setShowFiles model

                "JavaScriptInitialized" ->
                    ( model, loadPropertiesCommand )

                "PropertiesLoaded" ->
                    ( model, initializeStorageCommand model.properties.storageMethod )

                _ ->
                    model ! []

        _ ->
            model ! []


updateProperties : Decoder.Value -> Properties -> Properties
updateProperties incomingMessage currentProps =
    case Decoder.decodeValue (Decoder.field "type" Decoder.string) incomingMessage of
        Ok msg ->
            case msg of
                "PropertiesLoaded" ->
                    Debug.log "loading properties" <|
                        handlePropertiesLoaded currentProps incomingMessage

                _ ->
                    currentProps

        _ ->
            currentProps


innerUpdate : Decoder.Value -> FileStorageModel -> FileStorageModel
innerUpdate incomingMessage currentState =
    case Decoder.decodeValue (Decoder.field "type" Decoder.string) incomingMessage of
        Ok msg ->
            case msg of
                "FileList" ->
                    case Decoder.decodeValue (Decoder.field "files" fileListDecoder) incomingMessage of
                        Ok value ->
                            Debug.log "filelist" <|
                                { currentState | files = value }

                        Err err ->
                            Debug.log "Error in fs model update when getting files:"
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
                            Debug.log "Error during file load"
                                { currentState | lastError = Just err }

                "SaveSuccessful" ->
                    case Decoder.decodeValue (Decoder.field "metadata" metadataDecoder) incomingMessage of
                        Ok value ->
                            { currentState | currentFileStatus = Saved value }

                        Err err ->
                            Debug.log "Error detected in SaveSuccessul:"
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
                            Debug.log "Error encountered in SaveError:"
                                { currentState | lastError = Just err }

                _ ->
                    Debug.log ("Nothing found for " ++ (toString msg))
                        currentState

        Err err ->
            { currentState | lastError = Just err }


handlePropertiesLoaded : Properties -> Decoder.Value -> Properties
handlePropertiesLoaded currentProps value =
    value
        |> Decoder.decodeValue (Decoder.field "properties" propertiesDecoder)
        |> Result.withDefault currentProps


updateLinesShown : ( Model, Cmd msg ) -> ( Model, Cmd msg )
updateLinesShown ( model, command ) =
    ( { model | linesShown = getNumberOfLinesOnScreen model }, command )


metadataDecoder : Decoder.Decoder File
metadataDecoder =
    Decoder.map2 File
        (Decoder.field "title" Decoder.string)
        (Decoder.field "id" Decoder.string)



{- TODO handle position data from saved files properly


      object
          [ ( "contents", string <| String.join "\x0D\n" model.lines )
          , ( "cursorX", int <| model.cursorX )
          , ( "cursorY", int <| model.cursorY )
          , ( "firstLine", int <| model.firstLine )
          ]


   defaultBuffer =
       Buffer 0 0 "" 0


   type alias Buffer =
       { cursorX : Int
       , cursorY : Int
       , contents : String
       , firstLine : Int
       }


   decoder : Decoder Buffer
   decoder =
       map4 Buffer
           (field "cursorX" int)
           (field "cursorY" int)
           (field "contents" string)
           (field "firstLine" int)
-}
