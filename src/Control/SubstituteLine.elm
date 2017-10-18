module Control.SubstituteLine exposing (substituteLine)

import Model exposing (Model)
import Util.ListUtils exposing (getLine, mutateAtIndex, insertAtIndex, removeSlice)
import Mode exposing (Mode(..))
import Util.ModifierUtils exposing (getNumberModifier)


-- removeSlice : Int -> Int -> List String -> ( List String, PasteBuffer )


substituteLine : Model -> Model
substituteLine model =
    let
        { lines, cursorY } =
            model

        numberModifier =
            getNumberModifier model

        endIndex =
            if cursorY + numberModifier > List.length lines then
                List.length lines - 1
            else
                cursorY + numberModifier

        ( updatedLines, removed ) =
            removeSlice cursorY endIndex lines

        finalLines =
            insertAtIndex cursorY updatedLines ""
    in
        { model
            | mode = Insert
            , cursorX = 0
            , lines = finalLines
            , buffer = removed
        }
