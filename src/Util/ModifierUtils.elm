module Util.ModifierUtils exposing (..)

import Model exposing (..)


getNumberModifier : Model -> Int
getNumberModifier model =
    let
        numericChars =
            List.filter
                (\c -> List.member c [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' ])
                model.inProgress
    in
        getNumberFromCharList (List.reverse numericChars)


getNumberFromCharList : List Char -> Int
getNumberFromCharList chars =
    List.foldr String.cons "" chars
        |> String.toInt
        |> Result.withDefault 1
