module Handlers.NextWord exposing (handleW)

import Model exposing (Model)
import Util.ListUtils exposing (getLine)


-- one test case at a time


handleW : Model -> Model
handleW model =
    let
        { cursorY, cursorX, lines } =
            model

        currentLine =
            getLine cursorY lines

        xOffset =
            nextSpaceIndex (String.dropLeft cursorX currentLine)

        newOneLineIndex =
            xOffset + cursorX

        goToNextLine =
            newOneLineIndex == (String.length currentLine) && (List.length lines > (cursorY + 1))

        ( newCursorX, newCursorY ) =
            if goToNextLine then
                goToNextNonEmptyLine lines (cursorY + 1)
            else
                ( newOneLineIndex, cursorY )
    in
        { model | cursorX = newCursorX, cursorY = newCursorY }


nextSpaceIndex : String -> Int
nextSpaceIndex string =
    case String.uncons string of
        Just ( head, rest ) ->
            if head == ' ' then
                1
            else
                1 + nextSpaceIndex rest

        Nothing ->
            0


goToNextNonEmptyLine : List String -> Int -> ( Int, Int )
goToNextNonEmptyLine lines cursorY =
    let
        line =
            getLine cursorY lines
    in
        if String.trim line == "" then
            goToNextNonEmptyLine lines (cursorY + 1)
        else
            ( 0, cursorY )
