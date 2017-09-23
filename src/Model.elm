module Model exposing (..)

import Mode exposing (Mode(..))


type alias Model =
    { lines : List String
    , cursorX : Int
    , cursorY : Int
    , mode : Mode
    , inProgress : List Char
    , buffer : List String
    , firstLine : Int
    , pastStates : List State
    , futureStates : List State
    , searchString : String
    , searchStringBuffer : String
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
        []
        0
        []
        []
        ""
        ""
