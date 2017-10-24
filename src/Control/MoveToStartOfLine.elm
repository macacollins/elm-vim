module Control.MoveToStartOfLine exposing (moveToStartOfLine)

import Char
import Model exposing (Model)
import Util.ListUtils exposing (getLine)


moveToStartOfLine : Model -> Model
moveToStartOfLine model =
    if List.length (List.filter Char.isDigit model.numberBuffer) > 0 then
        { model | numberBuffer = '0' :: model.numberBuffer }
    else
        { model | cursorX = 0 }
