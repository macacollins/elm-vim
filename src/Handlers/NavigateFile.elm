module Handlers.NavigateFile exposing (..)

import Model exposing (Model)


handleG : Model -> Model
handleG model =
    let
        newCursorY =
            (List.length model.lines) - 1

        newFirstLine =
            -- TODO update when we page in a more mature fashion
            if newCursorY > 30 then
                newCursorY - 30
            else
                0
    in
        { model | cursorY = newCursorY, firstLine = newFirstLine }


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
