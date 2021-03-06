module Macro.Model exposing (..)

import Macro.ActionEntry exposing (ActionEntry)
import Dict exposing (Dict)
import Keyboard exposing (KeyCode)


type alias MacroModel =
    { buffer : List ActionEntry
    , rawBuffer : List KeyCode
    , macroMap : Dict Char (List ActionEntry)
    }


initialMacroModel : MacroModel
initialMacroModel =
    MacroModel
        []
        []
        Dict.empty


getMacro : Char -> MacroModel -> List ActionEntry
getMacro key model =
    case
        Dict.get key model.macroMap
    of
        Just actions ->
            actions

        Nothing ->
            []
