module Modes.Yank exposing (yankModeUpdate)

import Model exposing (Model)
import Keyboard exposing (KeyCode)
import Mode exposing (Mode(..))
import Modes.Control exposing (controlModeUpdate)
import Yank.YankLines exposing (..)
import Control.NavigateFile exposing (goToLineModeUpdate)
import Char
import Dict exposing (Dict)
import Modes.Delete exposing (deleteModeUpdate)


dict : Dict Char (Model -> Model)
dict =
    Dict.empty
        |> Dict.insert 'y' yankLines


yankModeUpdate : Model -> KeyCode -> ( Model, Cmd msg )
yankModeUpdate model keyCode =
    case model.mode of
        -- TODO This is nasty. Move to Yank and YankToLine
        Yank Control ->
            if Char.fromCode keyCode == 'g' then
                { model | mode = Yank GoToLine } ! []
            else
                yankModeNormalUpdate model keyCode

        Yank GoToLine ->
            if Char.fromCode keyCode == 'g' then
                wrapDelete model keyCode
            else
                yankModeNormalUpdate model keyCode

        _ ->
            yankModeNormalUpdate model keyCode


yankModeNormalUpdate : Model -> KeyCode -> ( Model, Cmd msg )
yankModeNormalUpdate model keyCode =
    case Dict.get (Char.fromCode keyCode) dict of
        Just handler ->
            handler model ! []

        Nothing ->
            if List.member (Char.fromCode keyCode) [ 'j', 'k', 'h', 'l', 'w', 'b', '$' ] then
                wrapDelete model keyCode
            else if List.isEmpty model.inProgress && Char.fromCode keyCode == '0' then
                wrapDelete model keyCode
            else if Char.isDigit (Char.fromCode keyCode) then
                controlModeUpdate model keyCode
            else
                { model | mode = Control } ! []


wrapDelete : Model -> KeyCode -> ( Model, Cmd msg )
wrapDelete model keyCode =
    let
        newInnerMode =
            case model.mode of
                Yank (_ as innerMode) ->
                    innerMode

                _ ->
                    Control

        modelWithMode =
            { model | mode = Delete newInnerMode }

        -- could get me into trouble later :D
        ( deletedModel, _ ) =
            deleteModeUpdate modelWithMode keyCode

        code =
            Char.fromCode keyCode

        -- messy
        ( moveModel, _ ) =
            if List.member code [ 'k', 'b', 'h', '0' ] then
                controlModeUpdate model keyCode
            else if code == 'g' then
                goToLineModeUpdate model
            else
                model ! []
    in
        { model
            | cursorX = moveModel.cursorX
            , cursorY = moveModel.cursorY
            , buffer = deletedModel.buffer
            , inProgress = []
            , mode = Control
        }
            ! []
