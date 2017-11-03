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

        trimmedLine =
            currentLine
                |> String.dropLeft actualCursorX
                |> String.toList
                |> dropWhile (\char -> char /= ' ')
                |> List.map (\char -> String.cons char "")
                |> String.join ""
                |> String.trimLeft

        newXIfSameLine =
            if String.length trimmedLine == 0 then
                String.length currentLine - 1
            else
                String.length currentLine - String.length trimmedLine

        ( newCursorX, newCursorY ) =
            if String.isEmpty trimmedLine && model.cursorY < List.length model.lines - 1 then
                goToNextNonEmptyLine model.lines (cursorY + 1)
            else
                ( newXIfSameLine, cursorY )

        updatedModel =
            { model | cursorX = newCursorX, cursorY = newCursorY }
    in
        if numberLeft > 1 then
            moveToNextWordInner
                updatedModel
                (numberLeft - 1)
        else
            { updatedModel | numberBuffer = [] }


dropWhile : (a -> Bool) -> List a -> List a
dropWhile selector list =
    case list of
        first :: rest ->
            if selector first then
                dropWhile selector rest
            else
                rest

        [] ->
            []


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

        newX =
            String.length line - (String.length (String.trimLeft line))
    in
        if restOfLinesAreEmpty then
            ( newX, cursorY )
        else if String.trim line == "" then
            ( 0, cursorY )
        else
            ( newX, cursorY )
