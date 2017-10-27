module View.Line exposing (Line(..), tildeLine)

import Html exposing (div, text)
import Html.Attributes exposing (class)


type Line
    = TextLine Int String
      -- fields are lineIndex, numberWrapped, contents
    | WrappedLine Int Int String
    | TildeLine


tildeLine =
    div [ class "tildeLine" ]
        [ text "~"
        ]
