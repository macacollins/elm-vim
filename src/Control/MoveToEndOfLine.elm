module Control.MoveToEndOfLine exposing (moveToEndOfLine)

import Char
import Model exposing (Model)
import Util.ListUtils exposing (getLine)


moveToEndOfLine : Model -> Model
moveToEndOfLine model =
    let
        length =
            String.length <| getLine model.cursorY model.lines

        zeroSafeLength =
            if length == 0 then
                0
            else
                length - 1
    in
        { model | cursorX = zeroSafeLength }
