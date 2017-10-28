module View.Top exposing (topView)

import Html exposing (..)
import Model exposing (Model)
import Mode exposing (Mode(..))
import Styles exposing (styleString)
import List exposing (..)
import Json.Encode exposing (string)
import View.PortsScript exposing (..)
import View.NormalLine exposing (..)
import Html.Attributes exposing (id)
import View.Line exposing (Line(..), tildeLine)
import View.Util exposing (getActualScreenWidth, getLinesInView, getLinesInView)


topView : Model -> Html msg
topView model =
    let
        lineRange =
            getLinesInView model

        tildeLines =
            if List.length lineRange == model.windowHeight then
                []
            else
                List.repeat (model.windowHeight - List.length lineRange) TildeLine

        lines =
            List.map (getNormalLineHTML model) (lineRange ++ tildeLines)

        styles =
            node "style" [] [ text <| styleString model ]

        mode =
            footer [ id "modeDisplay" ] <| modeFooter model

        children =
            styles :: mode :: portsScript :: lines
    in
        main_ [] children


foldLines : Model -> (Line -> List Line -> List Line)
foldLines model =
    let
        actualLineWidth =
            getActualScreenWidth model

        innerFold item list =
            case item of
                TextLine index text ->
                    if String.length text > actualLineWidth then
                        list ++ (split actualLineWidth index text)
                    else
                        list ++ [ item ]

                _ ->
                    list ++ [ item ]
    in
        innerFold


split : Int -> Int -> String -> List Line
split actualWidth lineNumber text =
    TextLine lineNumber (String.left actualWidth text) :: (splitInner actualWidth lineNumber 1 (String.dropLeft actualWidth text))


splitInner : Int -> Int -> Int -> String -> List Line
splitInner actualWidth lineNumber numberSoFar remainingText =
    if String.length remainingText > actualWidth then
        WrappedLine lineNumber numberSoFar (String.left actualWidth remainingText)
            :: splitInner actualWidth lineNumber (numberSoFar + 1) (String.dropLeft actualWidth remainingText)
    else
        [ WrappedLine lineNumber numberSoFar remainingText ]


modeFooter : Model -> List (Html msg)
modeFooter model =
    case model.mode of
        Command command ->
            [ pre []
                [ text command
                , span [ id "cursor" ] [ text " " ]
                ]
            ]

        _ ->
            [ text <| (toString model.mode ++ " " ++ model.searchStringBuffer) ]
