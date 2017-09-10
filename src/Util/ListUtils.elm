module Util.ListUtils exposing (..)

import List exposing (..)


getOrDefault : Int -> List a -> a -> a
getOrDefault index array default =
    case head <| drop (index) array of
        Just item ->
            item

        Nothing ->
            default


getLine : Int -> List String -> String
getLine index array =
    getOrDefault index array ""


removeAtIndex : Int -> List String -> ( List String, Maybe String )
removeAtIndex index list =
    let
        newList =
            (take index list)
                ++ drop (index + 1) list

        removedItem =
            head <| drop index list
    in
        if List.length newList == 0 then
            ( [ "" ], removedItem )
        else
            ( newList, removedItem )


insertAtIndex : Int -> List a -> a -> List a
insertAtIndex index list newItem =
    List.append (take index list) <|
        List.append [ newItem ]
            (drop index list)


mutateAtIndex : Int -> List a -> (a -> a) -> List a
mutateAtIndex index list transformer =
    case head <| drop index list of
        Just item ->
            (take index list) ++ [ transformer item ] ++ (drop (index + 1) list)

        Nothing ->
            list