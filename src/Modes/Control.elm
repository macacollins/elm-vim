module Modes.Control exposing (controlModeUpdate)

import Model exposing (..)
import Keyboard exposing (KeyCode)
import List exposing (..)
import Char
import Mode exposing (Mode(..))
import Handlers.DeleteCharacter exposing (..)
import Handlers.Delete exposing (..)
import Handlers.Undo exposing (..)
import Handlers.Redo exposing (..)
import Handlers.Paste exposing (handleP)
import Handlers.Navigation exposing (..)
import Handlers.PreviousWord exposing (..)
import Handlers.NextWord exposing (..)
import Handlers.NavigateFile exposing (..)
import Util.ListUtils exposing (..)
import History exposing (addHistory)


controlModeUpdate : Model -> KeyCode -> ( Model, Cmd msg )
controlModeUpdate model keyCode =
    let
        trash =
            Debug.log "Pressed" keyCode

        { lines, cursorX, cursorY } =
            model

        newModel =
            case keyCode of
                108 ->
                    -- l
                    handleRight model

                104 ->
                    -- h
                    handleLeft model

                106 ->
                    -- j
                    handleDown model

                107 ->
                    -- k
                    handleUp model

                100 ->
                    -- d
                    handleD model

                105 ->
                    -- i
                    addHistory model { model | mode = Insert }

                120 ->
                    -- x
                    addHistory model <| handleX model

                79 ->
                    -- O
                    let
                        updatedLines =
                            insertAtIndex (model.cursorY) lines ""
                    in
                        addHistory model
                            { model
                                | mode = Insert
                                , lines = updatedLines
                                , cursorX = 0
                            }

                111 ->
                    -- o
                    let
                        newCursorY =
                            model.cursorY + 1

                        updatedLines =
                            insertAtIndex (model.cursorY + 1) lines ""
                    in
                        addHistory model
                            { model
                                | mode = Insert
                                , cursorY = newCursorY
                                , cursorX = 0
                                , lines = updatedLines
                            }

                119 ->
                    handleW model

                112 ->
                    -- TODO shake out how this works when the paste buffer is empty.
                    -- It's fine for now... just a little unintuitive
                    addHistory model <|
                        handleP model

                98 ->
                    handleB model

                48 ->
                    -- 0
                    { model | cursorX = 0 }

                36 ->
                    -- $
                    { model | cursorX = String.length <| getLine model.cursorY model.lines }

                71 ->
                    handleG model

                103 ->
                    handleLittleG model

                117 ->
                    handleU model

                82 ->
                    handleR model

                _ ->
                    if 48 <= keyCode && keyCode <= 57 then
                        { model | inProgress = (Char.fromCode keyCode) :: model.inProgress }
                    else
                        model
    in
        ( newModel, Cmd.none )


addHistory : Model -> Model -> Model
addHistory lastModel newModel =
    { newModel | pastStates = getState lastModel :: lastModel.pastStates }
