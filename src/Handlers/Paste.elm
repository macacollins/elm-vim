module Handlers.Paste exposing (handleP)

import Model exposing (..)
import List
import Util.ListUtils exposing (..)


handleP : Model -> Model
handleP model =
    let
        newLines =
            insertMultiple (model.cursorY + 1) model.lines model.buffer
    in
        { model
            | lines = newLines
            , cursorX = 0
            , cursorY = model.cursorY + 1
        }
