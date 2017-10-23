port module Subscriptions exposing (subscriptions)

import Msg exposing (Msg(..))
import Keyboard
import Json.Decode exposing (Value)


subscriptions _ =
    Sub.batch
        [ Keyboard.presses KeyInput
        , Keyboard.ups KeyUp
        , updateCurrentBuffer AcceptBuffer
        ]



-- port for listening for suggestions from JavaScript


port updateCurrentBuffer : (Value -> msg) -> Sub msg
