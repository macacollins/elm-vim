module Control.PreviousWord exposing (..)

import Model exposing (Model)
import Util.ListUtils exposing (getLine)
import Util.ModifierUtils exposing (..)
import Control.CutSegment exposing (cutSegment)
import Mode exposing (Mode(Visual))
import Control.Navigation exposing (handleLeft)


handleB : Model -> Model
handleB model =
    let
        basicUpdatedModel =
            handleBInner model (getNumberModifier model)

        leftedModel =
            model

        leftUpdated =
            handleBInner leftedModel (getNumberModifier model)

        modifiedModelWithVisualModeHack =
            { model
                | mode = Visual (leftedModel.cursorX - 1) leftedModel.cursorY
                , cursorX = leftUpdated.cursorX
                , cursorY = leftUpdated.cursorY
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


handleBInner : Model -> Int -> Model
handleBInner model countDown =
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

        updatedModel =
            { model | cursorX = newCursorX, cursorY = newCursorY }
    in
        if countDown > 1 then
            handleBInner updatedModel (countDown - 1)
        else
            { updatedModel | inProgress = [] }


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

        allPreviousLinesEmpty =
            List.all (\line -> String.trim line == "") (List.take (cursorY + 1) lines)
    in
        if allPreviousLinesEmpty then
            ( 0, cursorY )
        else if String.trim line == "" then
            goToLastNonEmptyLine lines (cursorY - 1)
        else
            ( calculateLastWordStart line, cursorY )


calculateLastWordStart : String -> Int
calculateLastWordStart line =
    (String.length line)
        - (lastSpaceIndex (String.reverse line) False)
