module Handlers.NextWord exposing (handleW)

import Model exposing (Model)
import Util.ListUtils exposing (getLine)
import Util.ModifierUtils exposing (..)
import Handlers.CutSegment exposing (cutSegment)
import Handlers.Navigation exposing (handleLeft)
import Mode exposing (Mode(Visual))


{-
   This is problematic because it's tightly coupled. The cutSegment utility needs refactoring
   this pretends we're in visual mode and executing a cut, but the rules might not be identical.
   Let's write a ton of unit tests and see if this is actually feasible or no
-}


handleW : Model -> Model
handleW model =
    let
        basicUpdatedModel =
            handleWInner model (getNumberModifier model)

        leftedModel =
            handleLeft basicUpdatedModel

        modifiedModelWithVisualModeHack =
            { model
                | mode = Visual leftedModel.cursorX leftedModel.cursorY
            }
    in
        if List.member 'd' model.inProgress then
            let
                cutSegmentModel =
                    cutSegment modifiedModelWithVisualModeHack
            in
                { cutSegmentModel | inProgress = [] }
        else
            basicUpdatedModel


handleWInner : Model -> Int -> Model
handleWInner model numberLeft =
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
                goToNextNonEmptyLine lines (cursorY + 1)
            else
                ( newOneLineIndex, cursorY )

        updatedModel =
            { model | cursorX = newCursorX, cursorY = newCursorY }
    in
        if numberLeft > 1 then
            handleWInner
                updatedModel
                (numberLeft - 1)
        else
            { updatedModel | inProgress = [] }


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
