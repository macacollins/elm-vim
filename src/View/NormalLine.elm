module View.NormalLine exposing (getNormalLineHTML)

import Model exposing (Model)
import Html exposing (..)
import Html.Attributes exposing (class, id)
import View.Util exposing (..)
import Html.Attributes exposing (property, attribute)


getNormalLineHTML : Model -> Int -> String -> Html msg
getNormalLineHTML model index line =
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
                            [ replaceSpaceWithNbsp before
                            , span [ id "cursor" ] [ text <| middle ]
                            , replaceSpaceWithNbsp after
                            ]
            else
                replaceSpaceWithNbsp line
    in
        div [ class className ]
            [ span [ class "lineNumber" ] [ text paddedIndex ]
            , textContents
            ]
