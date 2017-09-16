module Util.ModifierUtils exposing (..)

import Model exposing (..)


getNumberModifier : Model -> Int
getNumberModifier model =
    let
        trash =
            model.inProgress

        numericChars =
            Debug.log "numericChars" <|
                List.filter
                    (\c -> List.member c [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' ])
                    model.inProgress
    in
        getNumberFromCharList numericChars


getNumberFromCharList : List Char -> Int
getNumberFromCharList chars =
    Result.withDefault 1 <|
        Debug.log "inted" <|
            String.toInt <|
                Debug.log "Consed" <|
                    List.foldr String.cons "" chars
