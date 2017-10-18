module Control.AppendAtEnd exposing (appendAtEnd)

import Model exposing (Model)
import Util.ListUtils exposing (getLine)
import Mode exposing (Mode(..))
import Util.ModifierUtils exposing (getNumberModifier)


-- removeSlice : Int -> Int -> List String -> ( List String, PasteBuffer )


appendAtEnd : Model -> Model
appendAtEnd model =
    let
        { lines, cursorY } =
            model

        line =
            getLine cursorY lines

        endIndex =
            String.length line
    in
        { model
            | mode = Insert
            , cursorX = endIndex
        }
