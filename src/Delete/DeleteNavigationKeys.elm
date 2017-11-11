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
        numberModifier =
            getNumberModifier model

        line =
            getLine model.cursorY model.lines

        newCursorX =
            if model.cursorX + numberModifier > String.length line then
                String.length line
            else
                model.cursorX + numberModifier

        updatedModel =
            { model
                | mode = Visual (newCursorX - 1) model.cursorY
                , cursorX = model.cursorX
            }
                |> cutSegment
    in
        { updatedModel
            | cursorX = newCursorX - numberModifier
            , numberBuffer = []
        }


deleteLeft : Model -> Model
deleteLeft model =
    let
        { cursorX } =
            moveLeft model

        numberModifier =
            getNumberModifier model

        newCursorX =
            if model.cursorX - numberModifier > 0 then
                model.cursorX - numberModifier
            else
                0

        updatedModel =
            if newCursorX == model.cursorX then
                { model | mode = Control }
            else
                { model
                    | mode = Visual newCursorX model.cursorY
                    , cursorX = model.cursorX - 1
                }
                    |> cutSegment
    in
        { updatedModel
            | cursorX = newCursorX
            , numberBuffer = []
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
