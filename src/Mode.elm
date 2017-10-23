module Mode exposing (Mode(..), NavigationType(..))

import Json.Decode exposing (Value)


type Mode
    = Control
    | Insert
      -- This is for when the user presses g
    | GoToLine
      -- This is cleaner than checking for (List.member 'd' inProgress)
    | Delete Mode
    | Yank Mode
    | Search
      -- this allows us to macro record arbitrary states (including Macro? not sure that's useful)
    | Macro Mode
    | MacroExecute
      -- Original X, original Y
    | Visual Int Int
    | NavigateToCharacter NavigationType
    | Command String



-- These are for t and f navigation


type NavigationType
    = Til
    | TilBack
    | To
    | ToBack
