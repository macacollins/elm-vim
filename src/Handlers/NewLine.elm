module Handlers.NewLine exposing (handleNewLine)

import Model exposing (Model)
import Array exposing (..)
import Util.ArrayUtils exposing (..)


handleNewLine : Model -> Model
handleNewLine model =
    let
        sliceIndex =
            (model.cursorY + 1)

        updatedLines =
            insertAtIndex sliceIndex model.lines ""

        newCursorY =
            model.cursorY + 1

        newCursorX =
            0
    in
        { model | lines = updatedLines, cursorY = newCursorY, cursorX = newCursorX }
