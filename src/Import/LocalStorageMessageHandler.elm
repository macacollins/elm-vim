module Import.LocalStorageMessageHandler exposing (acceptLocalStorageMessage, stringToLines)

import Model exposing (Model, initialModel)
import Json.Decode exposing (..)
import Char
import Properties exposing (propertiesDecoder, defaultProperties)


acceptLocalStorageMessage : Model -> Value -> ( Model, Cmd msg )
acceptLocalStorageMessage model incomingMessage =
    case decodeValue (field "type" string) incomingMessage of
        Ok msg ->
            case msg of
                "PropertiesLoaded" ->
                    handlePropertiesLoaded model incomingMessage

                "FileLoaded" ->
                    handleFileLoaded model incomingMessage

                _ ->
                    model ! []

        Err debugMessage ->
            Debug.log debugMessage <| model ! []


handlePropertiesLoaded : Model -> Value -> ( Model, Cmd msg )
handlePropertiesLoaded model value =
    let
        newProperties =
            value
                |> decodeValue (field "properties" propertiesDecoder)
                |> Result.withDefault defaultProperties
    in
        { model
            | properties = newProperties
        }
            ! []


handleFileLoaded : Model -> Value -> ( Model, Cmd msg )
handleFileLoaded model value =
    let
        buffer =
            value
                |> decodeValue decoder
                |> Result.withDefault defaultBuffer

        updatedLines =
            stringToLines buffer.contents
    in
        { model
            | cursorX = buffer.cursorX
            , cursorY = buffer.cursorY
            , lines = updatedLines
            , firstLine = buffer.firstLine
        }
            ! []



{-
   object
       [ ( "contents", string <| String.join "\x0D\n" model.lines )
       , ( "cursorX", int <| model.cursorX )
       , ( "cursorY", int <| model.cursorY )
       , ( "firstLine", int <| model.firstLine )
       ]
-}


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


stringToLines : String -> List String
stringToLines string =
    let
        removeRs string =
            string
                |> String.split (String.cons (Char.fromCode 13) "")
                |> String.join ""
                |> String.split (String.cons (Char.fromCode 10) "")
                |> String.join ""
    in
        string
            |> String.split "\n"
            |> List.map removeRs
