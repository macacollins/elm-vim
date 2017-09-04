module Handlers.NewLine exposing (handleNewLine)

import Model exposing (Model)
import Array exposing (..)


handleNewLine : Model -> Model
handleNewLine model =
    let
        sliceIndex =
            (model.cursorY + 1)

        updatedLines =
            Array.append (slice 0 sliceIndex model.lines) <|
                Array.append (fromList [ "" ])
                    (slice sliceIndex (Array.length model.lines) model.lines)

        newCursorY =
            model.cursorY + 1

        newCursorX =
            0
    in
        { model | lines = updatedLines, cursorY = newCursorY, cursorX = newCursorX }
