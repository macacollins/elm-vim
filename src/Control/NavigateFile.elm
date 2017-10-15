module Control.NavigateFile exposing (..)

import Model exposing (Model)
import Util.ListUtils exposing (getLine)
import Util.ModifierUtils exposing (..)
import Mode exposing (Mode(Control))


handleG : Model -> Model
handleG model =
    let
        cursorY =
            List.length model.lines - 1

        cursorX =
            (String.length <| getLine cursorY model.lines)
    in
        goToLineInner
            model
            cursorX
            cursorY


goToLineModeUpdate : Model -> ( Model, Cmd msg )
goToLineModeUpdate model =
    goToLineInner model 0 0 ! []


goToLineInner : Model -> Int -> Int -> Model
goToLineInner model defaultCursorX defaultCursorY =
    let
        ( newCursorX, newCursorY ) =
            if hasNumberModifier model then
                ( 0, actualModifierNumber )
            else
                ( defaultCursorX, defaultCursorY )

        newFirstLine =
            -- TODO update when we page in a more mature fashion
            if newCursorY > model.screenHeight then
                newCursorY - model.screenHeight
            else
                0

        numberModifier =
            getNumberModifier model

        actualModifierNumber =
            if numberModifier > List.length model.lines then
                defaultCursorY
            else
                numberModifier - 1
    in
        { model
            | cursorY = newCursorY
            , cursorX = newCursorX
            , firstLine = newFirstLine
            , mode = Control
        }
