module Update exposing (update)

import Char
import Msg exposing (Msg(..))

update msg model = 
  case msg of
    KeyInput keyPress ->
      (model ++ (String.cons (Char.fromCode keyPress) ""), Cmd.none)

