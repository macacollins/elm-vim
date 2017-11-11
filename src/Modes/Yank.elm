module Modes.Yank exposing (yankModeUpdate)

import Model exposing (Model, PasteBuffer(..))
import Keyboard exposing (KeyCode)
import Mode exposing (Mode(..), NavigationType(..))
import Modes.Control exposing (controlModeUpdate)
import Yank.YankLines exposing (..)
import Control.NavigateFile exposing (goToLineModeUpdate)
import Char
import Dict exposing (Dict)
import Modes.Delete exposing (deleteModeUpdate)


-- TODO strip out this dict structure


dict : Dict Char (Model -> Model)
dict =
    Dict.empty
        |> Dict.insert 'y' yankLines


yankModeUpdate : Model -> KeyCode -> ( Model, Cmd msg )
yankModeUpdate model keyCode =
    case model.mode of
        -- TODO Move this to a lookup table of some sort
        Yank Control ->
            if Char.fromCode keyCode == 'g' then
                { model | mode = Yank GoToLine } ! []
            else if Char.fromCode keyCode == 't' then
                { model | mode = Yank (NavigateToCharacter Til) } ! []
            else if Char.fromCode keyCode == 'f' then
                { model | mode = Yank (NavigateToCharacter To) } ! []
            else if Char.fromCode keyCode == 'F' then
                { model | mode = Yank (NavigateToCharacter ToBack) } ! []
            else if Char.fromCode keyCode == 'T' then
                { model | mode = Yank (NavigateToCharacter TilBack) } ! []
            else
                yankModeNormalUpdate model keyCode

        Yank GoToLine ->
            if Char.fromCode keyCode == 'g' then
                wrapDelete model keyCode
            else
                yankModeNormalUpdate model keyCode

        Yank (NavigateToCharacter _) ->
            wrapDelete model keyCode

        _ ->
            yankModeNormalUpdate model keyCode


yankModeNormalUpdate : Model -> KeyCode -> ( Model, Cmd msg )
yankModeNormalUpdate model keyCode =
    case Dict.get (Char.fromCode keyCode) dict of
        Just handler ->
            let
                updatedModel =
                    handler model
            in
                { updatedModel | numberBuffer = [] } ! []

        Nothing ->
            if List.member (Char.fromCode keyCode) [ 'j', 'k', 'h', 'l', 'w', 'b', '$', 'G', 'e' ] then
                wrapDelete model keyCode
            else if List.isEmpty model.numberBuffer && Char.fromCode keyCode == '0' then
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

        wrapsNavigateTo =
            case newInnerMode of
                NavigateToCharacter _ ->
                    True

                _ ->
                    False

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
            else if wrapsNavigateTo then
                deletedModel ! []
            else
                model ! []

        newBuffer =
            if
                wrapsNavigateTo
                    && deletedModel.lines
                    == model.lines
            then
                LinesBuffer []
            else
                deletedModel.buffer
    in
        { model
            | cursorX = moveModel.cursorX
            , cursorY = moveModel.cursorY
            , buffer = newBuffer
            , numberBuffer = []
            , mode = Control
        }
            ! []
