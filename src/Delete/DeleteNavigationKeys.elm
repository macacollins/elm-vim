module Delete.DeleteNavigationKeys exposing (deleteUp, deleteDown, deleteLeft, deleteRight)

import Model exposing (Model, PasteBuffer(..))
import Util.ListUtils exposing (getLine, removeSlice)
import Util.ModifierUtils exposing (..)
import Control.Move exposing (..)
import Control.CutSegment exposing (cutSegment)
import Mode exposing (Mode(..))


deleteRight : Model -> Model
deleteRight model =
    let
        { cursorX } =
            moveRight model

        updatedModel =
            { model
                | mode = Visual (model.cursorX) model.cursorY
                , cursorX = cursorX - 1
            }
                |> cutSegment
    in
        { updatedModel
            | cursorX = model.cursorX
        }


deleteLeft : Model -> Model
deleteLeft model =
    let
        { cursorX } =
            moveLeft model

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
            moveUp model
    in
        cutLines cursorY model.cursorY model


deleteDown : Model -> Model
deleteDown model =
    let
        { cursorY } =
            moveDown model
    in
        cutLines model.cursorY cursorY model



-- TODO handle firstLine adjustments


cutLines : Int -> Int -> Model -> Model
cutLines start finish model =
    let
        ( newLines, newBuffer ) =
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
        { model
            | lines = actualNewLines
            , buffer = newBuffer
            , cursorX = 0
            , cursorY = actualNewCursorY
            , numberBuffer = []
            , firstLine = newFirstLine
            , mode = Control
        }
