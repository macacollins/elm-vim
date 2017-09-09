module View exposing (view)

import Html exposing (..)
import Model exposing (Model)
import Array
import Styles exposing (styleString)
import Html.Attributes exposing (class, id)


view : Model -> Html msg
view model =
    let
        lines =
            Array.toList <| Array.indexedMap (getLine model) model.lines

        styles =
            node "style" [] [ text styleString ]

        children =
            styles :: lines
    in
        main_ [] children


getLine : Model -> Int -> String -> Html msg
getLine model index line =
    let
        className =
            "normalLine"

        textContents =
            if model.cursorY == index then
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
                            Debug.log "Cursor Text" <|
                                if String.length maybeMiddle == 0 then
                                    "_"
                                else
                                    maybeMiddle
                    in
                        span []
                            [ text <| before
                            , span [ id "cursor" ] [ text <| middle ]
                            , text <| after
                            ]
            else
                text line
    in
        div [ class className ]
            [ span [] [ text <| toString index ]
            , textContents
            ]
