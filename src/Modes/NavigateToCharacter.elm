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
            navigateForwardToCharacter model keyCode

        NavigateToCharacter Til ->
            navigateTilCharacter model keyCode

        NavigateToCharacter ToBack ->
            navigateBackwardToCharacter model keyCode

        NavigateToCharacter TilBack ->
            backToControlMode model

        _ ->
            backToControlMode model


backToControlMode : Model -> ( Model, Cmd msg )
backToControlMode model =
    { model | mode = Control } ! []


getStringFromKeycode =
    Char.fromCode >> String.fromChar


navigateForwardToCharacter : Model -> KeyCode -> ( Model, Cmd msg )
navigateForwardToCharacter model keyCode =
    let
        { lines, cursorX, cursorY } =
            model

        indices =
            getLine cursorY lines
                |> String.indices (getStringFromKeycode keyCode)
                |> List.filter (\n -> n > cursorX + 1)

        newCursorX =
            case indices of
                first :: _ ->
                    first

                _ ->
                    cursorX
    in
        { model | cursorX = newCursorX, mode = Control } ! []


navigateBackwardToCharacter : Model -> KeyCode -> ( Model, Cmd msg )
navigateBackwardToCharacter model keyCode =
    let
        { lines, cursorX, cursorY } =
            model

        indices =
            getLine cursorY lines
                |> String.indices (getStringFromKeycode keyCode)
                |> List.filter (\n -> n < cursorX)
                |> List.reverse

        newCursorX =
            case indices of
                first :: _ ->
                    first

                _ ->
                    cursorX
    in
        { model | cursorX = newCursorX, mode = Control } ! []


navigateTilCharacter : Model -> KeyCode -> ( Model, Cmd msg )
navigateTilCharacter model keyCode =
    let
        { lines, cursorX, cursorY } =
            model

        indices =
            getLine cursorY lines
                |> String.indices (getStringFromKeycode keyCode)
                |> List.filter (\n -> n > cursorX)

        newCursorX =
            case indices of
                first :: _ ->
                    first - 1

                _ ->
                    cursorX
    in
        { model | cursorX = newCursorX, mode = Control } ! []
