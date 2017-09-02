module Main exposing (main)

import Html
import View exposing (view)
import Update exposing (update)
import Init exposing (init)
import Subscriptions exposing (subscriptions)

main = Html.program {
  subscriptions = subscriptions
  , view = view
  , update = update
  , init = init
  }

