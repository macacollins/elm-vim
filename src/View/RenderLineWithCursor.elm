module View.RenderLineWithCursor exposing (renderLineWithCursor)

import Mode exposing (Mode(..))
import Model exposing (Model)
import Html exposing (..)
import Html.Attributes exposing (class, id)
import Html.Attributes exposing (property, attribute)


renderLineWithCursor : Model -> Int -> String -> Html msg
renderLineWithCursor model index line =
    if String.length line == 0 then
        span [ id "cursor" ] [ text " " ]
    else
        let
            adjustedCursorX =
                if String.length line <= model.cursorX then
                    case model.mode of
                        Insert ->
                            String.length line + 1

                        Macro _ Insert ->
                            String.length line + 1

                        _ ->
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
                    " "
                else if maybeMiddle == " " then
                    " "
                else
                    maybeMiddle
        in
            span []
                [ text before
                , span [ id "cursor" ] [ text <| middle ]
                , text after
                ]
