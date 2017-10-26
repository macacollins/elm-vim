module View.NormalLine exposing (getNormalLineHTML)

import Model exposing (Model)
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Attributes exposing (property, attribute)
import View.Util exposing (..)
import View.RenderLineWithCursor exposing (renderLineWithCursor)
import Mode exposing (Mode(..))
import View.VisualLine exposing (getVisualTextContents)
import View.Line exposing (Line(..), tildeLine)


getNormalLineHTML : Model -> Int -> Line -> Html msg
getNormalLineHTML model index line =
    case line of
        TextLine text ->
            getNormalLineInner model index text

        TildeLine ->
            tildeLine


getNormalLineInner : Model -> Int -> String -> Html msg
getNormalLineInner model index line =
    let
        textContents =
            case model.mode of
                Visual _ _ ->
                    getVisualTextContents model index line

                _ ->
                    if model.cursorY == actualIndex then
                        renderLineWithCursor model index line
                    else
                        replaceSpaceWithNbsp line

        actualIndex =
            index + model.firstLine

        padding =
            String.length <| toString <| List.length model.lines

        paddedIndex =
            String.padLeft padding '0' <| toString actualIndex
    in
        if model.properties.lineNumbers then
            div [ class "normalLine" ]
                [ span [ class "lineNumber" ] [ text paddedIndex ]
                , textContents
                ]
        else
            div [ class "normalLine" ]
                [ textContents
                ]
