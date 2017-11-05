module Control.InsertCharacter exposing (handleInsertCharacter)

import List exposing (..)
import Char
import Keyboard exposing (KeyCode)
import Model exposing (Model)
import Util.ListUtils exposing (..)


handleInsertCharacter : Model -> KeyCode -> Model
handleInsertCharacter model keyCode =
    let
        transformer currentLine =
            let
                indexToSplit =
                    model.cursorX

                before =
                    String.slice 0 indexToSplit currentLine

                after =
                    String.slice indexToSplit (String.length currentLine) currentLine
            in
                before
                    ++ (String.cons (Char.fromCode keyCode) "")
                    ++ after

        newLines =
            mutateAtIndex model.cursorY model.lines transformer

        newCursorX =
            if newLines == model.lines then
                model.cursorX
            else
                model.cursorX + 1
    in
        { model | lines = newLines, cursorX = newCursorX }
