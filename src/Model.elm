module Model exposing (..)

import Mode exposing (Mode(..))


type alias Model =
    { lines : List String
    , cursorX : Int
    , cursorY : Int
    , mode : Mode
    , inProgress : List Char
    , buffer : String
    , firstLine : Int
    , pastStates : List State
    }


type alias State =
    { lines : List String
    , cursorX : Int
    , cursorY : Int
    , firstLine : Int
    }


getState : Model -> State
getState model =
    State
        model.lines
        model.cursorX
        model.cursorY
        model.firstLine


initialModel =
    Model
        (List.repeat 1 "")
        0
        0
        Control
        []
        ""
        0
        []
