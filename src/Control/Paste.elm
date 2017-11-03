module Control.Paste exposing (handlePaste, handlePasteBefore)

import Macro.ActionEntry exposing (ActionEntry(..))
import Model exposing (..)
import List
import Util.ListUtils exposing (..)


addLastCommand : ActionEntry -> Model -> Model
addLastCommand action model =
    { model | lastAction = action }


handlePaste : Model -> Model
handlePaste model =
    addLastCommand (Keys "p") <|
        case model.buffer of
            LinesBuffer buffer ->
                { model
                    | lines = insertMultiple (model.cursorY + 1) model.lines buffer
                    , cursorX = 0
                    , cursorY =
                        if List.isEmpty buffer then
                            model.cursorY
                        else
                            model.cursorY + 1
                }

            InlineBuffer buffer ->
                insertInline model buffer


handlePasteBefore : Model -> Model
handlePasteBefore model =
    addLastCommand (Keys "P") <|
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
            let
                ( left, right ) =
                    splitLine (getLine cursorY lines) (cursorX - 1)
            in
                (mutateAtIndex cursorY lines (\line -> left ++ head ++ right))

        _ ->
            lines


insertInline : Model -> List String -> Model
insertInline model buffer =
    case buffer of
        head :: second :: rest ->
            let
                { cursorX, cursorY, lines } =
                    model

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
                { model
                    | lines = withLineAfter
                    , cursorY = lastLineIndex
                }

        head :: [] ->
            let
                line =
                    getLine model.cursorY model.lines

                newLines =
                    (mutateAtIndex model.cursorY model.lines (\line -> (String.left (model.cursorX + 1) line) ++ head ++ (String.dropLeft (model.cursorX + 1) line)))

                newCursorX =
                    model.cursorX + (String.length head) - 1
            in
                { model
                    | lines = newLines
                    , cursorX = newCursorX
                }

        _ ->
            model
