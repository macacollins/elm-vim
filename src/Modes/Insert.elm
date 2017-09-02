module Modes.Insert exposing (insertModeUpdate)

import Model exposing (Model)
import Keyboard exposing (KeyCode)
import Mode exposing (Mode(Control))
import Handlers.NewLine exposing (handleNewLine)
import Handlers.InsertCharacter exposing (handleInsertCharacter)

insertModeUpdate : Model -> KeyCode -> (Model, Cmd msg)
insertModeUpdate model keyCode =
      let 
          trash = 
            Debug.log "Pressed" keyCode

          newModel =
            case keyCode of 
              27 -> -- Escape key
                { model | mode = Control }

              13 -> -- Enter key
                handleNewLine model 

              _ -> 
                handleInsertCharacter model keyCode
      in
          (newModel, Cmd.none)

