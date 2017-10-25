module View.RenderLineWithCursor exposing (renderLineWithCursor)

import Mode exposing (Mode(..))
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
            adjustedCursorX =
                if String.length line <= model.cursorX then
                    if model.mode == Insert then
                        String.length line + 1
                    else
                        String.length line - 1
                else
                    model.cursorX

            before =
                String.slice 0 adjustedCursorX line

            maybeMiddle =
                String.slice adjustedCursorX (adjustedCursorX + 1) line

            after =
                String.slice (adjustedCursorX + 1) (String.length line + 1) line

            middle =
                if String.length maybeMiddle == 0 then
                    "_"
                else if maybeMiddle == " " then
                    "_"
                else
                    maybeMiddle
        in
            span []
                [ replaceSpaceWithNbsp before
                , span [ id "cursor" ] [ text <| middle ]
                , replaceSpaceWithNbsp after
                ]
