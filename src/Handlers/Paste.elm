module Handlers.Paste exposing (handleP)

import Model exposing (..)
import List
import Util.ListUtils exposing (..)


handleP : Model -> Model
handleP model =
    let
        newLines =
            case model.buffer of
                LinesBuffer buffer ->
                    insertMultiple (model.cursorY + 1) model.lines buffer

                InlineBuffer buffer ->
                    insertInline model buffer
    in
        { model
            | lines = newLines
            , cursorX = 0
            , cursorY = model.cursorY + 1
        }


insertInline : Model -> List String -> List String
insertInline { lines, cursorX, cursorY } buffer =
    case buffer of
        head :: rest ->
            mutateAtIndex cursorY lines (\line -> (String.left cursorX line) ++ head)

        _ ->
            lines


splitLine : String -> Int -> ( String, String )
splitLine string index =
    ( String.left index string, String.dropLeft index string )
