module Modes.ChangeText exposing (changeTextModeUpdate)

import Mode exposing (Mode(..))
import Model exposing (..)
import Modes.Delete exposing (deleteModeUpdate)
import Modes.Control exposing (controlModeUpdate)
import Keyboard exposing (KeyCode)
import Macro.ActionEntry exposing (ActionEntry(..))
import Char
import Dict


changeTextModeUpdate =
    3
