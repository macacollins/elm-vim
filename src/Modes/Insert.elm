module Modes.Insert exposing (insertModeUpdate)

import Model exposing (Model)
import Keyboard exposing (KeyCode)
import Mode exposing (Mode(Control))
import Control.NewLine exposing (handleNewLine)
import Control.InsertCharacter exposing (handleInsertCharacter)
import Control.DeleteCharacter exposing (handleBackspace)
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
        ( newModel, Cmd.none )
