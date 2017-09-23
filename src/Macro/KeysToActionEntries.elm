module Macro.KeysToActionEntries exposing (keysToActionEntries)

import Macro.ActionEntry exposing (ActionEntry(..))
import Keyboard exposing (KeyCode)
import Char


keysToActionEntries : List KeyCode -> List ActionEntry
keysToActionEntries keyCodes =
    keysToActionsInner keyCodes ""


keysToActionsInner : List KeyCode -> String -> List ActionEntry
keysToActionsInner remainingCodes progressString =
    case remainingCodes of
        code :: rest ->
            case getActionEntry code of
                Keys keyString ->
                    keysToActionsInner rest (progressString ++ keyString)

                _ as entry ->
                    if progressString == "" then
                        entry :: keysToActionsInner rest ""
                    else
                        Keys progressString :: entry :: keysToActionsInner rest ""

        [] ->
            if progressString == "" then
                []
            else
                [ Keys progressString ]


getActionEntry : KeyCode -> ActionEntry
getActionEntry actionEntry =
    case actionEntry of
        13 ->
            Enter

        27 ->
            Escape

        8 ->
            Backspace

        _ as other ->
            Keys (String.cons (Char.fromCode other) "")
