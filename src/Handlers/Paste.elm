module Handlers.Paste exposing (handleP)

import Model exposing (..)
import List
import Util.ListUtils exposing (..)


handleP : Model -> Model
handleP model =
    let
        newLines =
            case model.buffer of
                LinesBuffer buffer ->
                    insertMultiple (model.cursorY + 1) model.lines buffer

                InlineBuffer buffer ->
                    insertMultiple (model.cursorY + 1) model.lines buffer
    in
        { model
            | lines = newLines
            , cursorX = 0
            , cursorY = model.cursorY + 1
        }
