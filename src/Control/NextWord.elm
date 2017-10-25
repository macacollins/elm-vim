module Control.NextWord exposing (moveToNextWord)

import Model exposing (Model)
import Util.ListUtils exposing (getLine)
import Util.ModifierUtils exposing (..)
import Control.CutSegment exposing (cutSegment)
import Control.Move exposing (moveLeft)
import Mode exposing (Mode(Visual))


moveToNextWord : Model -> Model
moveToNextWord model =
    moveToNextWordInner model (getNumberModifier model)


moveToNextWordInner : Model -> Int -> Model
moveToNextWordInner model numberLeft =
    let
        { cursorY, cursorX, lines } =
            model

        currentLine =
            getLine cursorY lines

        actualCursorX =
            if cursorX > String.length currentLine then
                String.length currentLine
            else
                cursorX

        xOffset =
            nextSpaceIndex (String.dropLeft actualCursorX currentLine)

        newOneLineIndex =
            xOffset + actualCursorX

        goToNextLine =
            newOneLineIndex == (String.length currentLine) && (List.length lines > (cursorY + 1))

        ( newCursorX, newCursorY ) =
            if goToNextLine then
                ( 0, (cursorY + 1) )
            else
                ( newOneLineIndex, cursorY )

        updatedModel =
            { model | cursorX = newCursorX, cursorY = newCursorY }
    in
        if numberLeft > 1 then
            moveToNextWordInner
                updatedModel
                (numberLeft - 1)
        else
            { updatedModel | numberBuffer = [] }


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

        restOfLinesAreEmpty =
            List.all (\line -> String.trim line == "") (List.drop cursorY lines)
    in
        if restOfLinesAreEmpty then
            ( 0, cursorY )
        else if String.trim line == "" then
            goToNextNonEmptyLine lines (cursorY + 1)
        else
            ( 0, cursorY )
