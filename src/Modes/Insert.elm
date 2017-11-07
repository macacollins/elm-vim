module Modes.Insert exposing (insertModeUpdate)

import Modes.Control exposing (controlModeUpdate)
import Model exposing (Model)
import Keyboard exposing (KeyCode)
import Mode exposing (Mode(Control))
import Control.NewLine exposing (handleNewLine)
import Control.InsertCharacter exposing (handleInsertCharacter)
import Delete.DeleteCharacter exposing (handleBackspace)
import History exposing (addHistory)


insertModeUpdate : Model -> KeyCode -> ( Model, Cmd msg )
insertModeUpdate model keyCode =
    let
        newModel =
            case keyCode of
                27 ->
                    -- Escape key
                    { model
                        | mode = Control
                        , cursorX =
                            if model.cursorX > 0 then
                                model.cursorX - 1
                            else
                                0
                    }

                13 ->
                    -- Enter key
                    handleNewLine model

                8 ->
                    -- backspace, duh
                    handleBackspace model

                _ ->
                    handleInsertCharacter model keyCode
    in
        if List.member keyCode [ -4, -3, -2, -1 ] then
            -- TODO make the right arrow key go past the end of the line by 1 space in insert mode
            controlModeUpdate model keyCode
        else
            ( newModel, Cmd.none )
