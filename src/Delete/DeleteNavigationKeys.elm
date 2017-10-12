module Delete.DeleteNavigationKeys exposing (deleteUp, deleteDown, deleteLeft, deleteRight)

import Model exposing (Model, PasteBuffer(..))
import Util.ListUtils exposing (getLine, removeSlice)
import Util.ModifierUtils exposing (..)
import Control.Navigation exposing (..)
import Control.CutSegment exposing (cutSegment)
import Mode exposing (Mode(..))


deleteRight : Model -> Model
deleteRight model =
    let
        { cursorX } =
            handleRight model

        updatedModel =
            { model
                | mode = Visual model.cursorX model.cursorY
                , cursorX = cursorX - 1
            }
    in
        cutSegment updatedModel


deleteLeft : Model -> Model
deleteLeft model =
    let
        { cursorX } =
            handleLeft model

        numberModifier =
            getNumberModifier model

        updatedModel =
            { model
                | mode = Visual cursorX model.cursorY
                , cursorX = model.cursorX - 1
            }
                |> cutSegment
    in
        { updatedModel
            | cursorX = cursorX
        }


deleteUp : Model -> Model
deleteUp model =
    let
        { cursorY } =
            handleUp model
    in
        cutLines cursorY model.cursorY model


deleteDown : Model -> Model
deleteDown model =
    let
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
