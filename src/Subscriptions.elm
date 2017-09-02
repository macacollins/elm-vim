module Subscriptions exposing (subscriptions)

import Msg exposing (Msg(..))

import Keyboard

subscriptions _ =
  Keyboard.ups KeyInput

