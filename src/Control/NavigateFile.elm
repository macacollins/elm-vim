module Control.NavigateFile exposing (..)

import Model exposing (Model)
import Util.ListUtils exposing (getLine)
import Util.ModifierUtils exposing (..)
import Mode exposing (Mode(Control))


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


goToLineModeUpdate : Model -> ( Model, Cmd msg )
goToLineModeUpdate model =
    let
        ( newCursorX, newCursorY, newFirstLine, newInProgress ) =
            ( 0, 0, 0, [] )
    in
        { model
            | cursorY = newCursorY
            , cursorX = newCursorX
            , firstLine = newFirstLine
            , inProgress = newInProgress
            , mode = Control
        }
            ! []
