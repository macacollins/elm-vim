module Handlers.PreviousWord exposing (..)

import Model exposing (Model)
import Util.ListUtils exposing (getLine)


handleB : Model -> Model
handleB model =
    let
        { cursorY, cursorX, lines } =
            model

        actualCursorX =
            if cursorX > String.length currentLine then
                String.length currentLine
            else
                cursorX

        currentLine =
            getLine cursorY lines

        xOffset =
            lastSpaceIndex
                (String.reverse <|
                    (String.left actualCursorX currentLine)
                )
                False

        beforeCursorOnLine =
            String.trim <|
                String.left actualCursorX currentLine

        goToPreviousLine =
            beforeCursorOnLine == "" && cursorY > 0

        ( newCursorX, newCursorY ) =
            if goToPreviousLine then
                goToLastNonEmptyLine lines (cursorY - 1)
            else
                ( actualCursorX - xOffset, cursorY )
    in
        { model | cursorX = newCursorX, cursorY = newCursorY }


lastSpaceIndex : String -> Bool -> Int
lastSpaceIndex string hasSeenChar =
    case String.uncons string of
        Just ( head, rest ) ->
            if head == ' ' then
                if hasSeenChar then
                    0
                else
                    1 + lastSpaceIndex rest False
            else
                1 + lastSpaceIndex rest True

        Nothing ->
            0


goToLastNonEmptyLine : List String -> Int -> ( Int, Int )
goToLastNonEmptyLine lines cursorY =
    let
        line =
            getLine cursorY lines
    in
        if String.trim line == "" then
            goToLastNonEmptyLine lines (cursorY - 1)
        else
            ( calculateLastWordStart line, cursorY )


calculateLastWordStart : String -> Int
calculateLastWordStart line =
    (String.length line)
        - (lastSpaceIndex (String.reverse line) False)
