module Handlers.Delete exposing (handleDelete)

import Model exposing (Model)
import Array


handleDelete : Model -> Model
handleDelete model =
    let
        { lines, cursorY, cursorX } =
            model

        currentLine =
            case Array.get cursorY lines of
                Just theLine ->
                    theLine

                Nothing ->
                    ""

        updatedLine =
            (String.slice 0 cursorX currentLine) ++ (String.slice (cursorX + 1) (String.length currentLine) currentLine)

        finalLines =
            Array.append (Array.slice 0 cursorY lines) <|
                Array.append (Array.fromList [ updatedLine ]) <|
                    Array.slice (cursorY + 1) (Array.length lines) lines
    in
        { model | lines = finalLines }
