module Handlers.DeleteCharacter exposing (handleX)

import Model exposing (Model)
import Array
import Util.ArrayUtils exposing (..)


handleX : Model -> Model
handleX model =
    let
        { lines, cursorY, cursorX } =
            model

        updateLine currentLine =
            (String.slice 0 cursorX currentLine) ++ (String.slice (cursorX + 1) (String.length currentLine) currentLine)

        finalLines =
            mutateAtIndex cursorY lines updateLine
    in
        { model | lines = finalLines }
