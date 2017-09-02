module Init exposing (init)

import Array exposing (..)

import Model exposing (Model)
import Mode exposing (Mode(..))

initialModel = Model
     (repeat 1 "")
     0
     0
     Control

init = (initialModel, Cmd.none)

