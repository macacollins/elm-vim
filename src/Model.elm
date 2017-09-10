module Model exposing (Model, initialModel)

import Mode exposing (Mode(..))


type alias Model =
    { lines : List String
    , cursorX : Int
    , cursorY : Int
    , mode : Mode
    , inProgress : List Char
    , buffer : String
    , firstLine : Int
    }


initialModel =
    Model
        (List.repeat 1 "")
        0
        0
        Control
        []
        ""
        0
