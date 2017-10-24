module Control.Substitute exposing (substitute)

import Mode exposing (Mode(..))
import Model exposing (Model)
import Model exposing (PasteBuffer(..))
import Util.ListUtils exposing (getLine, mutateAtIndex, insertAtIndex, removeSlice)
import Util.ModifierUtils exposing (getNumberModifier)


-- removeSlice : Int -> Int -> List String -> ( List String, PasteBuffer )


substitute : Model -> Model
substitute model =
    let
        { lines, cursorY, cursorX } =
            model

        line =
            getLine cursorY lines

        righted =
            moveRight model

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
            , numberBuffer = []
        }


moveRight : Model -> Model
moveRight model =
    let
        numberModifier =
            getNumberModifier model

        currentLine =
            getLine model.cursorY model.lines

        newCursorX =
            if model.cursorX + numberModifier < String.length currentLine then
                model.cursorX + numberModifier
            else
                String.length currentLine
    in
        { model | cursorX = newCursorX, numberBuffer = [] }
