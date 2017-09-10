module View exposing (view)

import Html exposing (..)
import Model exposing (Model)
import Styles exposing (styleString)
import Html.Attributes exposing (class, id)
import List exposing (..)


view : Model -> Html msg
view model =
    let
        lineRange =
            take 31 <| drop model.firstLine model.lines

        lines =
            List.indexedMap (getLine model) lineRange

        styles =
            node "style" [] [ text styleString ]

        mode =
            footer [ id "modeDisplay" ]
                [ text <| toString model.mode ]

        children =
            styles :: mode :: lines
    in
        main_ [] children


getLine : Model -> Int -> String -> Html msg
getLine model index line =
    let
        className =
            "normalLine"

        actualIndex =
            index + model.firstLine

        padding =
            String.length <| toString <| List.length model.lines

        paddedIndex =
            String.padLeft padding '0' <| toString actualIndex

        textContents =
            if model.cursorY == actualIndex then
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
            [ span [ class "lineNumber" ] [ text paddedIndex ]
            , textContents
            ]
