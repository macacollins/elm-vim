module View.Top exposing (topView)

import Html exposing (..)
import Model exposing (Model)
import Styles exposing (styleString)
import List exposing (..)
import Json.Encode exposing (string)
import View.Util exposing (..)
import View.PortsScript exposing (..)
import View.NormalLine exposing (..)
import Html.Attributes exposing (id)


topView : Model -> Html msg
topView model =
    let
        lineRange =
            take model.screenHeight <| drop model.firstLine model.lines

        tildeLines =
            if List.length lineRange == model.screenHeight then
                []
            else
                List.repeat (model.screenHeight - List.length lineRange) "~"

        lines =
            List.indexedMap (getNormalLineHTML model) (lineRange ++ tildeLines)

        styles =
            node "style" [] [ text styleString ]

        mode =
            footer [ id "modeDisplay" ]
                [ text <| (toString model.mode ++ " " ++ model.searchStringBuffer) ]

        children =
            styles :: mode :: portsScript :: lines
    in
        main_ [] children
