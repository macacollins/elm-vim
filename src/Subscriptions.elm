port module Subscriptions exposing (subscriptions)

import Msg exposing (Msg(..))
import Keyboard
import Json.Decode exposing (Value)
import Window
import Drive exposing (fromDriveJavaScript)


subscriptions _ =
    Sub.batch
        [ Keyboard.presses KeyInput
        , Keyboard.ups KeyUp
        , localStorageToElm LocalStorageMessageHandler
        , paste Paste
        , fromDriveJavaScript UpdateFromDrive
        , Window.resizes WindowResized
        ]



-- port for getting buffers from localStorage in JavaScript


port localStorageToElm : (Value -> msg) -> Sub msg


port paste : (String -> msg) -> Sub msg
