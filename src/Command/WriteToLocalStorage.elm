port module Command.WriteToLocalStorage exposing (writeToLocalStorage)

import Model exposing (Model)
import Json.Encode exposing (..)
import Mode exposing (Mode(..))


-- port for sending strings out to JavaScript


port writeBufferPort : Value -> Cmd msg


writeToLocalStorage : Model -> ( Model, Cmd msg )
writeToLocalStorage model =
    { model | mode = Control } ! [ writeBufferPort <| getValue model ]


getValue : Model -> Value
getValue model =
    Debug.log "object" <|
        object
            [ ( "contents", string <| String.join "\x0D\n" model.lines )
            , ( "cursorX", int <| model.cursorX )
            , ( "cursorY", int <| model.cursorY )
            , ( "firstLine", int <| model.firstLine )
            ]
