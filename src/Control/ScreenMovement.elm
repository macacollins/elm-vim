module Control.ScreenMovement exposing (..)

import Model exposing (Model)


moveToTopOfScreen : Model -> Model
moveToTopOfScreen model =
    { model | cursorY = model.firstLine }


moveToBottomOfScreen : Model -> Model
moveToBottomOfScreen model =
    if model.firstLine + model.windowHeight > (List.length model.lines) then
        { model
            | cursorY = (List.length model.lines) - 1
        }
    else
        { model
            | cursorY = model.firstLine + model.windowHeight - 1
        }


moveToMiddleOfScreen : Model -> Model
moveToMiddleOfScreen model =
    let
        topPlusHalf =
            model.firstLine + (model.windowHeight // 2)

        newCursorY =
            if topPlusHalf >= List.length model.lines then
                List.length model.lines - 1
            else
                topPlusHalf
    in
        { model | cursorY = newCursorY }
