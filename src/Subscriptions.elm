module Subscriptions exposing (subscriptions)

import Msg exposing (Msg(..))

import Keyboard

subscriptions _ =
  Keyboard.presses KeyInput

