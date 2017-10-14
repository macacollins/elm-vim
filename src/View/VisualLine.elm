module View.VisualLine exposing (getVisualTextContents)

import Model exposing (Model)
import Mode exposing (Mode(..))
import Html exposing (..)
import Html.Attributes exposing (class, id)
import Html.Attributes exposing (property, attribute)
import View.Util exposing (..)
import View.RenderLineWithCursor exposing (renderLineWithCursor)
import Util.VisualUtils exposing (getStartAndEnd)


getVisualTextContents : Model -> Int -> String -> Html msg
getVisualTextContents model index line =
    let
        cursor =
            actualIndex == model.cursorY

        actualIndex =
            index + model.firstLine

        ( startX, startY, endX, endY ) =
            getStartAndEnd model
    in
        if startY == actualIndex && endY == actualIndex then
            if startX == endX then
                renderLineWithCursor model index line
            else
                renderLineWithVisualStartAndEnd model line
        else if startY == actualIndex then
            renderLineWithVisualStart model index line
        else if startY < actualIndex && actualIndex < endY then
            replaceSpaceWithNbspAndClass line "visual"
        else if endY == actualIndex then
            renderLineWithVisualEnd model index line
        else
            replaceSpaceWithNbsp line


renderLineWithVisualStartAndEnd model line =
    if String.length line == 0 then
        span [ id "cursor" ] [ text "_" ]
    else
        let
            ( startX, startY, endX, endY ) =
                getStartAndEnd model

            before =
                String.slice 0 startX line

            maybeMiddleStart =
                String.slice startX (startX + 1) line

            maybeMiddleInner =
                String.slice (startX + 1) endX line

            maybeMiddleEnd =
                String.slice endX (endX + 1) line

            after =
                String.slice (endX + 1) (String.length line + 1) line

            selectedIndexStart =
                if String.length maybeMiddleStart == 0 then
                    "_"
                else
                    maybeMiddleStart

            selectedIndexEnd =
                if String.length maybeMiddleEnd == 0 then
                    "_"
                else
                    maybeMiddleEnd
        in
            span []
                [ replaceSpaceWithNbsp before
                , span [ id "cursor" ] [ text <| selectedIndexStart ]
                , replaceSpaceWithNbspAndClass maybeMiddleInner "visual"
                , span [ id "cursor" ] [ text <| selectedIndexEnd ]
                , replaceSpaceWithNbsp after
                ]


renderLineWithVisualStart model index line =
    if String.length line == 0 then
        span [ id "cursor" ] [ text "_" ]
    else
        let
            ( startX, startY, endX, endY ) =
                getStartAndEnd model

            before =
                String.slice 0 startX line

            maybeMiddle =
                String.slice startX (startX + 1) line

            after =
                String.slice (startX + 1) (String.length line + 1) line

            middle =
                if String.length maybeMiddle == 0 then
                    "_"
                else
                    maybeMiddle
        in
            span []
                [ replaceSpaceWithNbsp before
                , span [ id "cursor" ] [ text <| middle ]
                , replaceSpaceWithNbspAndClass after "visual"
                ]


renderLineWithVisualEnd model index line =
    if String.length line == 0 then
        span [ id "cursor" ] [ text "_" ]
    else
        let
            ( _, _, endX, endY ) =
                getStartAndEnd model

            before =
                String.slice 0 endX line

            maybeMiddle =
                String.slice endX (endX + 1) line

            after =
                String.slice (endX + 1) (String.length line + 1) line

            middle =
                if String.length maybeMiddle == 0 then
                    "_"
                else
                    maybeMiddle
        in
            span []
                [ replaceSpaceWithNbspAndClass before "visual"
                , span [ id "cursor" ] [ text <| middle ]
                , replaceSpaceWithNbsp after
                ]
