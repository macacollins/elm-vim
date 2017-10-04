module Main exposing (main)

import Html
import View.Top exposing (topView)
import Update exposing (update)
import Init exposing (init)
import Subscriptions exposing (subscriptions)
import Model exposing (Model)
import Msg exposing (Msg)


main : Program Never Model Msg
main =
    Html.program
        { subscriptions = subscriptions
        , view = topView
        , update = update
        , init = init
        }
