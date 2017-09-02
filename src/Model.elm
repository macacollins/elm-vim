module Model exposing (Model)

import Array exposing (Array)

import Mode exposing (Mode(..))

type alias Model =
  { lines : Array String
  , cursorX : Int
  , cursorY : Int
  , mode : Mode
  }



