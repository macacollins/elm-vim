module Properties exposing (Properties, defaultProperties, encodeProperties, decodeProperties, propertiesDecoder)

-- TODO rename to Preferences

import Theme exposing (Theme(..))
import Storage exposing (StorageMethod(..))
import Json.Decode as Decoder
import Json.Encode as Encoder


defaultProperties : Properties
defaultProperties =
    { testsFromMacros = False
    , lineNumbers = True
    , relativeLineNumbers = False
    , theme = Day
    , storageMethod = LocalStorage
    }


type alias Properties =
    { testsFromMacros : Bool
    , lineNumbers : Bool
    , relativeLineNumbers : Bool
    , theme : Theme
    , storageMethod : StorageMethod
    }


encodeProperties : Properties -> Encoder.Value
encodeProperties properties =
    Encoder.object
        [ ( "testsFromMacros", Encoder.bool properties.testsFromMacros )
        , ( "lineNumbers", Encoder.bool properties.lineNumbers )
        , ( "relativeLineNumbers", Encoder.bool properties.relativeLineNumbers )
        , ( "theme", Encoder.string <| toString properties.theme )
        , ( "storageMethod", Encoder.string <| toString properties.storageMethod )
        ]


propertiesDecoder : Decoder.Decoder Properties
propertiesDecoder =
    Decoder.map5 Properties
        (Decoder.field "testsFromMacros" Decoder.bool)
        (Decoder.field "lineNumbers" Decoder.bool)
        (Decoder.field "relativeLineNumbers" Decoder.bool)
        (Decoder.field "theme" themeDecoder)
        (Decoder.field "storageMethod" storageMethodDecoder)


themeDecoder : Decoder.Decoder Theme
themeDecoder =
    Decoder.map
        (\value ->
            if value == "Day" then
                Day
            else if value == "Night" then
                Night
            else
                defaultProperties.theme
        )
        Decoder.string


storageMethodDecoder : Decoder.Decoder StorageMethod
storageMethodDecoder =
    Decoder.map
        (\value ->
            if value == "LocalStorage" then
                LocalStorage
            else if value == "GoogleDrive" then
                GoogleDrive
            else
                defaultProperties.storageMethod
        )
        Decoder.string


decodeProperties : Decoder.Value -> Properties
decodeProperties value =
    Decoder.decodeValue propertiesDecoder value
        |> Result.withDefault defaultProperties
