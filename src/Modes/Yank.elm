module Modes.Yank exposing (yankModeUpdate)

import Model exposing (Model)
import Keyboard exposing (KeyCode)
import Mode exposing (Mode(Control))
import Modes.Control exposing (controlModeUpdate)
import Yank.YankLines exposing (..)
import Char
import Dict exposing (Dict)


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
            else
                { model | mode = Control } ! []
