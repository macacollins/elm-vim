module Control.DeleteToEndOfLine exposing (deleteToEndOfLine)

import Model exposing (Model, PasteBuffer(..))
import Util.ListUtils exposing (mutateAtIndex, getLine)


-- mutateAtIndex : Int -> List a -> (a -> a) -> List a


deleteToEndOfLine : Model -> Model
deleteToEndOfLine model =
    let
        updatedLines =
            mutateAtIndex model.cursorY model.lines (\line -> String.dropRight ((String.length line) - model.cursorX) line)

        updatedBuffer =
            getLine model.cursorY model.lines
                |> String.dropLeft model.cursorX
                |> List.singleton
                |> InlineBuffer
    in
        { model | lines = updatedLines, buffer = updatedBuffer }
