module Delete.DeleteNavigationKeys exposing (deleteUp, deleteDown)

import Model exposing (Model, PasteBuffer(..))
import Util.ListUtils exposing (getLine, removeSlice)
import Util.ModifierUtils exposing (..)
import Control.Navigation exposing (..)


deleteUp : Model -> Model
deleteUp model =
    let
        numberModifier =
            getNumberModifier model

        { cursorY } =
            handleUp model
    in
        cutLines cursorY model.cursorY model


deleteDown : Model -> Model
deleteDown model =
    let
        numberModifier =
            getNumberModifier model

        { cursorY } =
            handleDown model
    in
        cutLines model.cursorY cursorY model



-- TODO handle firstLine adjustments


cutLines : Int -> Int -> Model -> Model
cutLines start finish model =
    let
        ( newLines, maybeRemoved ) =
            removeSlice start (finish + 1) model.lines

        actualNewLines =
            if newLines == [] then
                [ "" ]
            else
                newLines

        newFirstLine =
            if start < model.firstLine then
                start
            else
                model.firstLine

        actualNewCursorY =
            if List.length newLines == 0 then
                0
            else if start < List.length newLines then
                start
            else
                List.length newLines - 1
    in
        case maybeRemoved of
            Just removed ->
                { model
                    | lines = actualNewLines
                    , buffer = LinesBuffer removed
                    , cursorX = 0
                    , cursorY = actualNewCursorY
                    , inProgress = []
                    , firstLine = newFirstLine
                }

            _ ->
                model
