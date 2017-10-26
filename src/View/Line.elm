module View.Line exposing (Line(..), tildeLine)

import Html exposing (div, text)
import Html.Attributes exposing (class)


type Line
    = TextLine String
    | TildeLine


tildeLine =
    div [ class "tildeLine" ]
        [ text "~"
        ]
