module Util.VisualUtils exposing (getStartAndEnd)

import Model exposing (Model)
import Mode exposing (Mode(..))


getStartAndEnd : Model -> ( Int, Int, Int, Int )
getStartAndEnd model =
    let
        ( visualX, visualY ) =
            case model.mode of
                Visual x y ->
                    ( x, y )

                _ ->
                    Debug.log "We weren't in visual mode in the visual mode update file." ( 0, 0 )
    in
        if model.cursorY < visualY then
            ( model.cursorX, model.cursorY, visualX, visualY )
        else if visualY < model.cursorY then
            ( visualX, visualY, model.cursorX, model.cursorY )
        else if (visualX < model.cursorX) then
            ( visualX, visualY, model.cursorX, model.cursorY )
        else
            ( model.cursorX, model.cursorY, visualX, visualY )
