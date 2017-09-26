module Handlers.JoinLines exposing (joinLines)

import Util.ListUtils exposing (getLine, removeAtIndex, mutateAtIndex)
import Model exposing (Model)


joinLines : Model -> Model
joinLines model =
    let
        ( withRemoved, removedLine ) =
            removeAtIndex (model.cursorY + 1) model.lines

        newLines =
            case removedLine of
                Just line ->
                    mutateAtIndex model.cursorY withRemoved <|
                        \oldLine -> oldLine ++ " " ++ (String.trim line)

                Nothing ->
                    model.lines
    in
        { model | lines = newLines }
