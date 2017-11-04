module Control.NavigateFile exposing (..)

import Model exposing (Model)
import Util.ListUtils exposing (getLine)
import Util.ModifierUtils exposing (..)
import Mode exposing (Mode(Control))
import View.Util exposing (..)
import View.Line exposing (Line(..))


goToLine : Model -> Model
goToLine model =
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

        numberModifier =
            getNumberModifier model

        actualModifierNumber =
            if numberModifier > List.length model.lines then
                defaultCursorY
            else
                numberModifier - 1

        partiallyUpdatedModel =
            { model
                | cursorY = newCursorY
                , cursorX = newCursorX
            }

        proposedFirstLine =
            if newCursorY >= model.windowHeight then
                newCursorY - model.windowHeight + 1
            else
                0

        newFirstLine =
            calculateFirstLine partiallyUpdatedModel proposedFirstLine
    in
        { model
            | cursorY = newCursorY
            , cursorX = newCursorX
            , firstLine = newFirstLine
            , mode = Control
            , numberBuffer = []
        }


calculateFirstLine : Model -> Int -> Int
calculateFirstLine model proposedFirstLine =
    let
        linesInView =
            getLinesInView { model | firstLine = proposedFirstLine }

        lineVisible =
            linesInView
                |> List.any (matchesLine model.cursorY)
    in
        if lineVisible then
            proposedFirstLine
        else
            calculateFirstLine model <| proposedFirstLine + 1


matchesLine : Int -> Line -> Bool
matchesLine cursorY line =
    case line of
        TextLine index _ ->
            index == cursorY

        _ ->
            False
