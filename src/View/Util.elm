module View.Util exposing (..)

import Html exposing (..)
import Html.Attributes exposing (property, attribute, class)


replaceSpaceWithNbsp : String -> Html msg
replaceSpaceWithNbsp input =
    span [ class "line-container" ] <| processString input <| Space 0


replaceSpaceWithNbspAndClass : String -> String -> Html msg
replaceSpaceWithNbspAndClass input className =
    span [ class ("line-container " ++ className) ] <| processString input <| Space 0


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
