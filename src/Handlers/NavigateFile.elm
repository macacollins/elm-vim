module Handlers.NavigateFile exposing (..)

import Model exposing (Model)
import Util.ListUtils exposing (getLine)
import Util.ModifierUtils exposing (..)


handleG : Model -> Model
handleG model =
    let
        defaultCursorY =
            (List.length model.lines) - 1

        defaultCursorX =
            String.length <| getLine defaultCursorY model.lines

        newFirstLine =
            -- TODO update when we page in a more mature fashion
            if newCursorY > 30 then
                newCursorY - 30
            else
                0

        numberModifier =
            getNumberModifier model

        actualModifierNumber =
            if numberModifier > List.length model.lines then
                defaultCursorY
            else
                numberModifier

        ( newCursorX, newCursorY ) =
            if hasNumberModifier model then
                ( 0, actualModifierNumber )
            else
                ( defaultCursorX, defaultCursorY )
    in
        { model
            | cursorY = newCursorY
            , firstLine = newFirstLine
            , cursorX = newCursorX
        }


handleLittleG : Model -> Model
handleLittleG model =
    let
        ( newCursorX, newCursorY, newFirstLine, newInProgress ) =
            if List.member 'g' model.inProgress then
                ( 0, 0, 0, [] )
            else
                ( model.cursorX, model.cursorY, model.firstLine, 'g' :: model.inProgress )
    in
        { model
            | cursorY = newCursorY
            , cursorX = newCursorX
            , firstLine = newFirstLine
            , inProgress = newInProgress
        }
