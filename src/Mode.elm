module Mode exposing (Mode(..), NavigationType(..))

import Json.Decode exposing (Value)
import Message exposing (Message)


type Mode
    = StartingMessage
    | ShowMessage Message Mode
    | Control
    | Insert
    | ChangeText
    | ChangeToCharacter NavigationType
    | ChangeToLine
      -- This is for when the user presses g
    | GoToLine
      -- This is cleaner than checking for (List.member 'd' numberBuffer)
    | Delete Mode
    | Yank Mode
    | Search
      -- this allows us to macro record arbitrary states (including Macro? not sure that's useful)
    | EnterMacroName
    | Macro Char Mode
    | MacroExecute
      -- Original X, original Y
    | Visual Int Int
    | NavigateToCharacter NavigationType
    | Command String
      -- SearchString, Index
    | FileSearch String Int



-- These are for t and f navigation


type NavigationType
    = Til
    | TilBack
    | To
    | ToBack
