module Util.ArrayUtils exposing (..)

import Array exposing (..)


getOrDefault : Int -> Array a -> a -> a
getOrDefault index array default =
    case get index array of
        Just item ->
            item

        Nothing ->
            default


getLine : Int -> Array String -> String
getLine index array =
    getOrDefault index array ""


removeAtIndex : Int -> Array String -> ( Array String, Maybe String )
removeAtIndex index array =
    let
        newArray =
            Array.append (Array.slice 0 index array) <|
                Array.slice (index + 1) (Array.length array) array

        removedItem =
            Array.get index array
    in
        if Array.length newArray == 0 then
            ( Array.fromList [ "" ], removedItem )
        else
            ( newArray, removedItem )


insertAtIndex : Int -> Array a -> a -> Array a
insertAtIndex index array newItem =
    Array.append (slice 0 index array) <|
        Array.append (fromList [ newItem ])
            (slice index (Array.length array) array)


mutateAtIndex : Int -> Array a -> (a -> a) -> Array a
mutateAtIndex index array transformer =
    case get index array of
        Just item ->
            set index (transformer item) array

        Nothing ->
            array
