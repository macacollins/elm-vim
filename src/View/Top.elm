module View.Top exposing (topView)

import Html exposing (..)
import Model exposing (Model)
import Mode exposing (Mode(..))
import Styles exposing (styleString)
import List exposing (..)
import Json.Encode exposing (string)
import View.Util exposing (..)
import View.PortsScript exposing (..)
import View.NormalLine exposing (..)
import Html.Attributes exposing (id)
import View.Line exposing (Line(..), tildeLine)


topView : Model -> Html msg
topView model =
    let
        lineRange =
            model.lines
                |> drop model.firstLine
                |> take model.screenHeight
                |> List.map TextLine

        tildeLines =
            if List.length lineRange == model.screenHeight then
                []
            else
                List.repeat (model.screenHeight - List.length lineRange) TildeLine

        lines =
            List.indexedMap (getNormalLineHTML model) (lineRange ++ tildeLines)

        styles =
            node "style" [] [ text styleString ]

        mode =
            footer [ id "modeDisplay" ] <| modeFooter model

        children =
            styles :: mode :: portsScript :: lines
    in
        main_ [] children


modeFooter : Model -> List (Html msg)
modeFooter model =
    case model.mode of
        Command command ->
            [ text command
            , span [ id "cursor" ] [ text "_" ]
            ]

        _ ->
            [ text <| (toString model.mode ++ " " ++ model.searchStringBuffer) ]
