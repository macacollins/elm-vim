module Handlers.Paste exposing (handlePaste, handlePasteBefore)

import Model exposing (..)
import List
import Util.ListUtils exposing (..)


handlePaste : Model -> Model
handlePaste model =
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


handlePasteBefore : Model -> Model
handlePasteBefore model =
    let
        newLines =
            case model.buffer of
                LinesBuffer buffer ->
                    insertMultiple model.cursorY model.lines buffer

                InlineBuffer buffer ->
                    insertBeforeInline model buffer
    in
        { model
            | lines = newLines
            , cursorX = 0
        }


insertBeforeInline : Model -> List String -> List String
insertBeforeInline { lines, cursorX, cursorY } buffer =
    case buffer of
        head :: second :: rest ->
            let
                insertLine =
                    getLine cursorY lines

                ( left, right ) =
                    splitLine insertLine (cursorX - 1)

                withLineBefore =
                    mutateAtIndex cursorY lines (\_ -> left ++ head)

                withLinesInserted =
                    insertMultiple (cursorY + 1) withLineBefore (second :: rest)

                lastLineIndex =
                    cursorY + List.length buffer - 1

                withLineAfter =
                    mutateAtIndex lastLineIndex withLinesInserted (\line -> line ++ right)
            in
                withLineAfter

        head :: [] ->
            (mutateAtIndex cursorY lines (\line -> (String.left cursorX line) ++ head))

        _ ->
            lines


insertInline : Model -> List String -> List String
insertInline { lines, cursorX, cursorY } buffer =
    case buffer of
        head :: second :: rest ->
            let
                insertLine =
                    getLine cursorY lines

                ( left, right ) =
                    splitLine insertLine (cursorX + 1)

                withLineBefore =
                    mutateAtIndex cursorY lines (\_ -> left ++ head)

                withLinesInserted =
                    insertMultiple (cursorY + 1) withLineBefore (second :: rest)

                lastLineIndex =
                    cursorY
                        + List.length buffer
                        - 1

                withLineAfter =
                    mutateAtIndex lastLineIndex withLinesInserted (\line -> line ++ right)
            in
                withLineAfter

        head :: [] ->
            (mutateAtIndex cursorY lines (\line -> (String.left (cursorX + 1) line) ++ head))

        _ ->
            lines
