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
        head :: second :: rest ->
            let
                trash =
                    Debug.log "buffer" buffer

                trash2 =
                    Debug.log "lines" lines

                insertLine =
                    getLine cursorY lines
                        |> Debug.log "Mutating"

                ( left, right ) =
                    splitLine insertLine (cursorY - 1)
                        |> Debug.log "Left and Right"

                withLineBefore =
                    mutateAtIndex cursorY lines (\_ -> left ++ head)
                        |> Debug.log "withLineBefore"

                withLinesInserted =
                    insertMultiple (cursorY + 1) withLineBefore (second :: rest)
                        |> Debug.log "withLinesInserted"

                lastLineIndex =
                    cursorY
                        + List.length buffer
                        - 1
                        |> Debug.log "lastLineIndex"

                withLineAfter =
                    mutateAtIndex lastLineIndex withLinesInserted (\line -> line ++ right)
                        |> Debug.log "withLineAfter"
            in
                withLineAfter

        head :: [] ->
            (mutateAtIndex cursorY lines (\line -> (String.left (cursorX + 1) line) ++ head))

        _ ->
            lines


splitLine : String -> Int -> ( String, String )
splitLine string index =
    ( String.left (index + 1) string, String.dropLeft (index + 1) string )
