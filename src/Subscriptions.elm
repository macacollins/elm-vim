module Subscriptions exposing (subscriptions)

import Msg exposing (Msg(..))
import Keyboard


subscriptions _ =
    Sub.batch
        [ Keyboard.presses KeyInput
        , Keyboard.ups KeyUp
        ]
