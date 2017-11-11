module Control.EnterAppendMode exposing (enterAppendMode)

import Model exposing (Model)
import Util.ListUtils exposing (getLine)
import Mode exposing (Mode(..))


enterAppendMode : Model -> Model
enterAppendMode model =
    let
        line =
            getLine (model.cursorY) model.lines

        newCursorX =
            if String.length line == 0 then
                0
            else if model.cursorX < String.length line then
                model.cursorX + 1
            else
                String.length line
    in
        { model
            | mode = Insert
            , cursorX = newCursorX
        }
