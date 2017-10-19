module Control.Substitute exposing (substitute)

import Model exposing (Model)
import Util.ListUtils exposing (getLine, mutateAtIndex, insertAtIndex, removeSlice)
import Mode exposing (Mode(..))
import Util.ModifierUtils exposing (getNumberModifier)
import Control.Navigation exposing (handleRight)
import Model exposing (PasteBuffer(..))


-- removeSlice : Int -> Int -> List String -> ( List String, PasteBuffer )


substitute : Model -> Model
substitute model =
    let
        { lines, cursorY, cursorX } =
            model

        line =
            getLine cursorY lines

        righted =
            handleRight model

        endX =
            righted.cursorX

        updatedLines =
            mutateAtIndex cursorY lines (\line -> String.left cursorX line ++ String.dropLeft endX line)

        removed =
            line
                |> String.left endX
                |> String.dropLeft cursorX

        newBuffer =
            if removed == "" then
                LinesBuffer []
            else
                InlineBuffer [ removed ]
    in
        { model
            | mode = Insert
            , lines = updatedLines
            , buffer = newBuffer
            , inProgress = []
        }
