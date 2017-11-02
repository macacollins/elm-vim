port module Command.WriteToLocalStorage
    exposing
        ( writeToLocalStorage
        , writeProperties
        , loadPropertiesCommand
        )

import Model exposing (Model)
import Json.Encode exposing (..)
import Mode exposing (Mode(..))
import Properties exposing (Properties, encodeProperties)


-- port for sending strings out to JavaScript
-- TODO switch to the single port to rule them all


port localStorageToJavaScript : Value -> Cmd msg


writeProperties : Model -> ( Model, Cmd msg )
writeProperties model =
    { model | mode = Control } ! [ localStorageToJavaScript <| writePropertiesCommand model.properties ]


writePropertiesCommand : Properties -> Value
writePropertiesCommand properties =
    object
        [ ( "type", string "WriteProperties" )
        , ( "payload", encodeProperties properties )
        ]


loadProperties : Model -> ( Model, Cmd msg )
loadProperties model =
    { model | mode = Control } ! [ loadPropertiesCommand ]


loadPropertiesCommand : Cmd msg
loadPropertiesCommand =
    localStorageToJavaScript <|
        object
            [ ( "type", string "LoadProperties" )
            ]


loadFromLocalStorage : Model -> String -> ( Model, Cmd msg )
loadFromLocalStorage model name =
    { model | mode = Control } ! [ localStorageToJavaScript <| getLoadCommand name ]


getLoadCommand : String -> Value
getLoadCommand name =
    object
        [ ( "type", string "LoadFile" )
        , ( "name"
          , string name
          )
        ]


writeToLocalStorage : Model -> ( Model, Cmd msg )
writeToLocalStorage model =
    { model | mode = Control } ! [ localStorageToJavaScript <| getWriteFileCommand model ]


getWriteFileCommand : Model -> Value
getWriteFileCommand model =
    object
        [ ( "type", string "WriteFile" )
        , ( "payload"
          , object
                [ ( "contents", string <| String.join "\x0D\n" model.lines )
                , ( "cursorX", int <| model.cursorX )
                , ( "cursorY", int <| model.cursorY )
                , ( "firstLine", int <| model.firstLine )
                , ( "name", string "saved" )
                ]
          )
        ]
