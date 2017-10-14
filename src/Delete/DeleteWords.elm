module Delete.DeleteWords exposing (..)

import Control.PreviousWord exposing (..)
import Control.NextWord exposing (navigateToNextWord)
import Control.Navigation exposing (handleLeft)
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
            navigateToLastWord leftedModel

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
            { cutSegmentModel | inProgress = [] }


deleteToNextWord : Model -> Model
deleteToNextWord model =
    let
        leftedModel =
            model
                |> navigateToNextWord
                |> handleLeft

        endLine =
            getLine leftedModel.cursorY model.lines

        ( deleteLine, cursorX, cursorY ) =
            Debug.log "delete, x, y" <|
                if leftedModel.cursorX == 0 && String.trim endLine /= "" then
                    -- we need to leave the line as is
                    if leftedModel.cursorY == 0 then
                        -- this is confusing; is it possible to get here? Empty file would do it
                        ( False, leftedModel.cursorX, leftedModel.cursorY )
                    else
                        let
                            line =
                                getLine (leftedModel.cursorY - 1) model.lines
                        in
                            ( True, String.length line - 1, leftedModel.cursorY - 1 )
                else
                    ( False, leftedModel.cursorX, leftedModel.cursorY )

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
    in
        { cutSegmentModel | inProgress = [], lines = withExtraDeletedLine }
