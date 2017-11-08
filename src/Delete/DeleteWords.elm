module Delete.DeleteWords exposing (..)

import Control.PreviousWord exposing (..)
import Control.NextWord exposing (moveToNextWord)
import Control.NextWord exposing (moveToNextWord)
import Control.MoveToEndOfWord exposing (moveToEndOfWord)
import Control.Move exposing (moveLeft)
import Control.CutSegment exposing (cutSegment)
import Util.ListUtils exposing (getLine, removeAtIndex)
import Util.ModifierUtils exposing (..)
import Mode exposing (Mode(Visual))
import Model exposing (Model)


{-
   This is problematic because it's tightly coupled. The cutSegment utility needs refactoring
   this pretends we're in visual mode and executing a cut, but the rules might not be identical.
   Let's write a ton of unit tests and see if this is actually feasible or no
-}


deleteBackWords : Model -> Model
deleteBackWords model =
    let
        leftedModel =
            model

        leftUpdated =
            moveToLastWord leftedModel

        modifiedModelWithVisualModeHack =
            { model
                | mode = Visual (leftedModel.cursorX - 1) leftedModel.cursorY
                , cursorX = leftUpdated.cursorX
                , cursorY = leftUpdated.cursorY
            }
    in
        let
            cutSegmentModel =
                cutSegment modifiedModelWithVisualModeHack
        in
            { cutSegmentModel | numberBuffer = [] }


deleteToNextWord : Model -> Model
deleteToNextWord model =
    let
        leftedModel =
            model
                |> moveToNextWord
                |> moveLeft

        endLine =
            getLine leftedModel.cursorY model.lines

        ( deleteLine, moveCursorXBack, cursorX, cursorY ) =
            if leftedModel.cursorX == 0 then
                -- we need to leave the line as is
                if leftedModel.cursorY == 0 then
                    -- this is confusing; is it possible to get here? Empty file would do it
                    ( False, False, leftedModel.cursorX, leftedModel.cursorY )
                else
                    let
                        line =
                            getLine (leftedModel.cursorY - 1) model.lines
                    in
                        if model.cursorX == 0 then
                            ( True, False, String.length line - 1, leftedModel.cursorY - 1 )
                        else
                            ( False, True, String.length line - 1, leftedModel.cursorY - 1 )
            else
                ( False, False, leftedModel.cursorX, leftedModel.cursorY )

        modifiedModelWithVisualModeHack =
            { model
                | mode = Visual cursorX cursorY
            }

        cutSegmentModel =
            cutSegment modifiedModelWithVisualModeHack

        ( withExtraDeletedLine, _ ) =
            if deleteLine then
                removeAtIndex model.cursorY cutSegmentModel.lines
            else
                ( cutSegmentModel.lines, Nothing )

        newCursorX =
            if moveCursorXBack then
                model.cursorX - 1
            else
                model.cursorX
    in
        { cutSegmentModel
            | numberBuffer = []
            , lines = withExtraDeletedLine
            , cursorX = newCursorX
        }


deleteToEndOfWord : Model -> Model
deleteToEndOfWord model =
    let
        leftedModel =
            model
                |> moveToEndOfWord

        endLine =
            getLine leftedModel.cursorY model.lines

        ( cursorX, cursorY ) =
            ( leftedModel.cursorX, leftedModel.cursorY )

        deleteLine =
            getLine leftedModel.cursorY leftedModel.lines
                |> String.trimLeft
                |> String.toList
                |> List.all (\char -> char /= ' ')

        moveCursorXBack =
            model.cursorX /= 0 && (deleteLine || model.cursorY == List.length model.lines - 1)

        modifiedModelWithVisualModeHack =
            { model
                | mode = Visual cursorX cursorY
            }

        cutSegmentModel =
            cutSegment modifiedModelWithVisualModeHack

        ( withExtraDeletedLine, _ ) =
            if deleteLine then
                removeAtIndex model.cursorY cutSegmentModel.lines
            else
                ( cutSegmentModel.lines, Nothing )

        newCursorX =
            if moveCursorXBack then
                model.cursorX - 1
            else
                model.cursorX
    in
        { cutSegmentModel
            | numberBuffer = []
            , lines = withExtraDeletedLine
            , cursorX = newCursorX
        }
