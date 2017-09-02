module Handlers.InsertCharacter exposing (handleInsertCharacter)

import Array exposing (..)
import Char
import Keyboard exposing (KeyCode)
import Model exposing (Model)

handleInsertCharacter : Model -> KeyCode -> Model
handleInsertCharacter model keyCode =
    let
          currentLine : String
          currentLine = 
            case get model.cursorY model.lines of
              Just line -> line
              Nothing -> ""

          indexToSplit =
              model.cursorX
  
          before = String.slice 0 indexToSplit currentLine
          after  = String.slice indexToSplit (String.length currentLine) currentLine
 
          withNewCharacter : String
          withNewCharacter =
              before ++ (String.cons (Char.fromCode keyCode) "") ++ after

          updatedLines : Array String
          updatedLines =
            set model.cursorY withNewCharacter model.lines

          newCursorX =
            if String.length currentLine == String.length withNewCharacter then
              model.cursorX
            else
              model.cursorX + 1
    in
        { model | lines = updatedLines, cursorX = newCursorX }

