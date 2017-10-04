module Util.ModifierUtils exposing (..)

import Model exposing (..)


getNumberModifier : Model -> Int
getNumberModifier model =
    model
        |> getNumericCharactersFromInProgress
        |> getNumberFromCharList


getNumericCharactersFromInProgress : Model -> List Char
getNumericCharactersFromInProgress model =
    model.inProgress
        |> List.filter
            (\c -> List.member c [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' ])
        |> List.reverse


hasNumberModifier : Model -> Bool
hasNumberModifier model =
    getNumericCharactersFromInProgress model
        |> List.isEmpty
        |> not


getNumberFromCharList : List Char -> Int
getNumberFromCharList chars =
    chars
        |> List.foldr String.cons ""
        |> String.toInt
        |> Result.withDefault 1
