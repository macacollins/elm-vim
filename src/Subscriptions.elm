port module Subscriptions exposing (subscriptions)

import Msg exposing (Msg(..))
import Keyboard
import Json.Decode exposing (Value)
import Window


subscriptions _ =
    Sub.batch
        [ Keyboard.presses KeyInput
        , Keyboard.ups KeyUp
        , updateCurrentBuffer AcceptBuffer
        , Window.resizes WindowResized
        ]



-- port for getting buffers from localStorage in JavaScript


port updateCurrentBuffer : (Value -> msg) -> Sub msg
