module Delete.DeleteWords exposing (..)

import Control.PreviousWord exposing (..)
import Control.NextWord exposing (navigateToNextWord)
import Control.Navigation exposing (handleLeft)
import Control.CutSegment exposing (cutSegment)
import Util.ListUtils exposing (getLine)
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

        modifiedModelWithVisualModeHack =
            { model
                | mode = Visual leftedModel.cursorX leftedModel.cursorY
            }
    in
        let
            cutSegmentModel =
                cutSegment modifiedModelWithVisualModeHack
        in
            { cutSegmentModel | inProgress = [] }
