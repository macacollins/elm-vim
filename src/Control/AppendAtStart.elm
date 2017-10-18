module Control.AppendAtStart exposing (appendAtStart)

import Model exposing (Model)
import Util.ListUtils exposing (getLine)
import Mode exposing (Mode(..))
import Util.ModifierUtils exposing (getNumberModifier)


-- removeSlice : Int -> Int -> List String -> ( List String, PasteBuffer )


appendAtStart : Model -> Model
appendAtStart model =
    { model
        | mode = Insert
        , cursorX = 0
    }
