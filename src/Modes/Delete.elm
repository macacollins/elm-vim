module Modes.Delete exposing (deleteModeUpdate)

import Model exposing (Model)
import Keyboard exposing (KeyCode)
import Mode exposing (Mode(Control))
import Delete.Delete exposing (..)
import Delete.DeleteToEndOfLine exposing (..)
import Delete.DeleteCharacter exposing (..)
import Modes.Control exposing (controlModeUpdate)
import Char
import Dict exposing (Dict)
import Control.Navigation exposing (..)
import Control.PreviousWord exposing (..)
import Control.NextWord exposing (..)


dict : Dict Char (Model -> Model)
dict =
    Dict.empty
        |> Dict.insert 'd' handleD
        -- TODO move this to next word
        |> Dict.insert 'w' deleteToNextWord
        |> Dict.insert 'b' deleteBackOneWord
        |> Dict.insert 'j' deleteDown
        |> Dict.insert 'k' deleteUp
        |> Dict.insert '$' deleteToEndOfLine


deleteModeUpdate : Model -> KeyCode -> ( Model, Cmd msg )
deleteModeUpdate model keyCode =
    case Dict.get (Char.fromCode keyCode) dict of
        Just handler ->
            handler model ! []

        Nothing ->
            if Char.isDigit (Char.fromCode keyCode) then
                controlModeUpdate model keyCode
            else
                { model | mode = Control } ! []
