module Msg exposing (Msg(..))

import Keyboard exposing (KeyCode)
import Json.Decode exposing (Value)


type Msg
    = KeyInput KeyCode
    | KeyUp KeyCode
    | AcceptBuffer Value
