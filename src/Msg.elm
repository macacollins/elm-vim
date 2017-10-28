module Msg exposing (Msg(..))

import Keyboard exposing (KeyCode)
import Json.Decode exposing (Value)
import Window


type Msg
    = KeyInput KeyCode
    | KeyUp KeyCode
    | AcceptBuffer Value
    | WindowResized Window.Size
    | Paste String
