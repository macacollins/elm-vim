module Model exposing (Model, initialModel)

import Array exposing (..)
import Mode exposing (Mode(..))


type alias Model =
    { lines : Array String
    , cursorX : Int
    , cursorY : Int
    , mode : Mode
    , inProgress : List Char
    }


initialModel =
    Model
        (repeat 1 "")
        0
        0
        Control
        []
