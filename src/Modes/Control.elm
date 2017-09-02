module Modes.Control exposing (controlModeUpdate)

import Model exposing (Model)
import Keyboard exposing (KeyCode)
import Array exposing (..)
import Char

import Mode exposing (Mode(..))

controlModeUpdate : Model -> KeyCode -> (Model, Cmd msg)
controlModeUpdate model keyCode =
      let 
          trash = 
            Debug.log "Pressed" keyCode

          newModel =
            case keyCode of
              76 -> -- h 
                  { model | cursorX = model.cursorX + 1 }

              72 -> -- l 
                  { model | cursorX = model.cursorX - 1 }

              74 -> -- j
                if model.cursorY == length model.lines - 1 then
                  model
                else
                  { model | cursorY = model.cursorY + 1 }

              75 -> -- k
                if model.cursorY == 0 then
                  model
                else
                  { model | cursorY = model.cursorY - 1 }

              73 -> -- i
                { model | mode = Insert }

              _ -> model

       in 
           (newModel, Cmd.none)          

