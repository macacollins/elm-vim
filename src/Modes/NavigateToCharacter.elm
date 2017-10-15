module Modes.NavigateToCharacter exposing (navigateToCharacterModeUpdate)

import Model exposing (Model)
import Keyboard exposing (KeyCode)
import Mode exposing (Mode(..), NavigationType(..))
import Modes.Control exposing (controlModeUpdate)
import Yank.YankLines exposing (..)
import Control.NavigateFile exposing (goToLineModeUpdate)
import Char
import Dict exposing (Dict)
import Util.ListUtils exposing (getLine)


navigateToCharacterModeUpdate : Model -> KeyCode -> ( Model, Cmd msg )
navigateToCharacterModeUpdate model keyCode =
    case model.mode of
        NavigateToCharacter To ->
            backToControlMode model

        NavigateToCharacter Til ->
            navigateTilCharacter model keyCode

        NavigateToCharacter ToBack ->
            backToControlMode model

        NavigateToCharacter TilBack ->
            backToControlMode model

        _ ->
            backToControlMode model


backToControlMode : Model -> ( Model, Cmd msg )
backToControlMode model =
    { model | mode = Control } ! []


navigateTilCharacter : Model -> KeyCode -> ( Model, Cmd msg )
navigateTilCharacter model keyCode =
    let
        { lines, cursorX } =
            model

        line =
            getLine cursorX lines

        indexToCut =
            if cursorX == 0 then
                0
            else
                cursorX - 1

        remainingLineSegment =
            String.dropLeft (indexToCut + 1) line

        singleCharString =
            String.cons (Char.fromCode keyCode) ""

        indices =
            String.indices singleCharString remainingLineSegment

        newCursorX =
            case indices of
                first :: _ ->
                    cursorX + first

                _ ->
                    cursorX
    in
        { model | cursorX = newCursorX, mode = Control } ! []
