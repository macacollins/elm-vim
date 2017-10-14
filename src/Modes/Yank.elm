module Modes.Yank exposing (yankModeUpdate)

import Model exposing (Model)
import Keyboard exposing (KeyCode)
import Mode exposing (Mode(Control))
import Modes.Control exposing (controlModeUpdate)
import Yank.YankLines exposing (..)
import Char
import Dict exposing (Dict)
import Modes.Delete exposing (deleteModeUpdate)


dict : Dict Char (Model -> Model)
dict =
    Dict.empty
        |> Dict.insert 'y' yankLines


yankModeUpdate : Model -> KeyCode -> ( Model, Cmd msg )
yankModeUpdate model keyCode =
    case Dict.get (Char.fromCode keyCode) dict of
        Just handler ->
            handler model ! []

        Nothing ->
            if Char.isDigit (Char.fromCode keyCode) then
                controlModeUpdate model keyCode
            else if List.member (Char.fromCode keyCode) [ 'j', 'k', 'w', 'b' ] then
                wrapDelete model keyCode
            else
                { model | mode = Control } ! []


wrapDelete : Model -> KeyCode -> ( Model, Cmd msg )
wrapDelete model keyCode =
    let
        -- could get me into trouble later :D
        ( deletedModel, _ ) =
            deleteModeUpdate model keyCode

        -- messy
        ( moveModel, _ ) =
            if List.member (Char.fromCode keyCode) [ 'k', 'b' ] then
                controlModeUpdate model keyCode
            else
                model ! []

        updatedModel =
            { model
                | cursorX = moveModel.cursorX
                , cursorY = moveModel.cursorY
                , buffer = deletedModel.buffer
                , inProgress = []
                , mode = Control
            }
                |> Debug.log "Updated model"
    in
        updatedModel ! []
