module Import.AcceptBuffer exposing (acceptBuffer)

import Model exposing (Model, initialModel)
import Json.Decode exposing (..)


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


acceptBuffer : Model -> Value -> ( Model, Cmd msg )
acceptBuffer model value =
    let
        buffer =
            value
                |> decodeValue decoder
                |> Result.withDefault defaultBuffer
    in
        { model
            | cursorX = buffer.cursorX
            , cursorY = buffer.cursorY
            , lines = String.split "\n" buffer.contents
            , firstLine = buffer.firstLine
        }
            ! []
