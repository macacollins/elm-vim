module Delete.DeleteToStartOfLine exposing (deleteToStartOfLine)

import Model exposing (Model, PasteBuffer(..))
import Util.ListUtils exposing (mutateAtIndex, getLine)


-- mutateAtIndex : Int -> List a -> (a -> a) -> List a


deleteToStartOfLine : Model -> Model
deleteToStartOfLine model =
    let
        { cursorX, cursorY, lines } =
            model

        updatedLines =
            mutateAtIndex cursorY lines (\line -> String.dropLeft cursorX line)

        updatedBuffer =
            getLine cursorY lines
                |> String.left cursorX
                |> List.singleton
                |> InlineBuffer
    in
        { model
            | lines = updatedLines
            , buffer = updatedBuffer
            , cursorX = 0
            , inProgress = []
        }
