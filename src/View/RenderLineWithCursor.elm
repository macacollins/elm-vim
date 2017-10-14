module View.RenderLineWithCursor exposing (renderLineWithCursor)

import Model exposing (Model)
import Html exposing (..)
import Html.Attributes exposing (class, id)
import Html.Attributes exposing (property, attribute)
import View.Util exposing (..)


renderLineWithCursor : Model -> Int -> String -> Html msg
renderLineWithCursor model index line =
    if String.length line == 0 then
        span [ id "cursor" ] [ text "_" ]
    else
        let
            before =
                String.slice 0 model.cursorX line

            maybeMiddle =
                String.slice model.cursorX (model.cursorX + 1) line

            after =
                String.slice (model.cursorX + 1) (String.length line + 1) line

            middle =
                if String.length maybeMiddle == 0 then
                    "_"
                else
                    maybeMiddle
        in
            span []
                [ replaceSpaceWithNbsp before
                , span [ id "cursor" ] [ text <| middle ]
                , replaceSpaceWithNbsp after
                ]
