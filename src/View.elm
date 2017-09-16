module View exposing (view)

import Html exposing (..)
import Model exposing (Model)
import Styles exposing (styleString)
import Html.Attributes exposing (class, id)
import List exposing (..)
import Json.Encode exposing (string)
import Html.Attributes exposing (property, attribute)


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


replaceSpaceWithNbsp : String -> Html msg
replaceSpaceWithNbsp input =
    span [ class "line-container" ] <| processString input <| Space 0


type InProgress
    = Space Int
    | Characters String


getNbsp : Int -> Html msg
getNbsp num =
    span [ attribute "style" "visibility: hidden" ] [ text <| (String.repeat num ".") ]


processString : String -> InProgress -> List (Html msg)
processString input progress =
    case String.uncons input of
        Just ( head, rest ) ->
            case progress of
                Space currentSpaces ->
                    if head == ' ' then
                        processString rest <| Space <| currentSpaces + 1
                    else
                        getNbsp currentSpaces :: (processString rest <| Characters <| String.cons head "")

                Characters currentString ->
                    if head == ' ' then
                        span [] [ text currentString ] :: (processString rest <| Space 1)
                    else
                        processString rest <| Characters <| currentString ++ String.cons head ""

        _ ->
            case progress of
                Space currentSpaces ->
                    [ getNbsp currentSpaces ]

                Characters currentString ->
                    [ span [] [ text currentString ] ]


replace : String -> String -> String -> String
replace from to input =
    String.split from input |> String.join to
