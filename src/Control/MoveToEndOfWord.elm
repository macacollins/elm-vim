module Control.MoveToEndOfWord exposing (moveToEndOfWord)

import Model exposing (Model)
import Util.ListUtils exposing (getLine)
import Util.ModifierUtils exposing (..)
import Control.CutSegment exposing (cutSegment)
import Control.Move exposing (moveLeft)
import Mode exposing (Mode(Visual))


moveToEndOfWord : Model -> Model
moveToEndOfWord model =
    moveToEndOfWordInner model (getNumberModifier model)


moveToEndOfWordInner : Model -> Int -> Model
moveToEndOfWordInner model numberLeft =
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
            trimLine currentLine (actualCursorX + 1)

        newXIfSameLine =
            if String.length trimmedLine == 0 then
                String.length currentLine - 1
            else
                String.length currentLine - String.length trimmedLine - 1

        zeroProofNewXIfSameLine =
            if newXIfSameLine < 0 then
                0
            else
                newXIfSameLine

        ( newCursorX, newCursorY ) =
            if String.isEmpty trimmedLine && model.cursorY < List.length model.lines - 1 then
                goToNextNonEmptyLine model.lines (cursorY + 1)
            else
                ( zeroProofNewXIfSameLine, cursorY )

        updatedModel =
            { model | cursorX = newCursorX, cursorY = newCursorY }
    in
        if numberLeft > 1 then
            moveToEndOfWordInner
                updatedModel
                (numberLeft - 1)
        else
            { updatedModel | numberBuffer = [] }


trimLine : String -> Int -> String
trimLine string actualCursorX =
    string
        |> String.dropLeft actualCursorX
        |> String.trimLeft
        |> String.toList
        |> dropWhile (\char -> char /= ' ')
        |> List.map (\char -> String.cons char "")
        |> String.join ""


dropWhile : (a -> Bool) -> List a -> List a
dropWhile selector list =
    case list of
        first :: rest ->
            if selector first then
                dropWhile selector rest
            else
                first :: rest

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

        trimmedLine =
            trimLine line 0

        newX =
            String.length line - (String.length trimmedLine) - 1

        zeroProofNewX =
            if newX < 0 then
                0
            else
                newX

        emptyLinesY =
            if List.isEmpty lines then
                0
            else
                List.length lines - 1
    in
        if restOfLinesAreEmpty then
            ( 0, emptyLinesY )
        else if String.trim line == "" then
            goToNextNonEmptyLine lines <| cursorY + 1
        else
            -- we have a non-empty line
            ( zeroProofNewX, cursorY )
