port module Subscriptions exposing (subscriptions)

import Msg exposing (Msg(..))
import Keyboard
import Json.Decode exposing (Value)
import Window


subscriptions _ =
    Sub.batch
        [ Keyboard.presses KeyInput
        , Keyboard.ups KeyUp
        , paste Paste
        , fromFileStorageJavaScript HandleFileStorageMessage
        , Window.resizes WindowResized
        ]



-- port for getting buffers from localStorage in JavaScript


port fromFileStorageJavaScript : (Value -> msg) -> Sub msg


port paste : (String -> msg) -> Sub msg
