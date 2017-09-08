module Update exposing (update)

import Char
import Msg exposing (Msg(..))
import Model exposing (Model)
import Mode exposing (Mode(..))
import Modes.Control exposing (controlModeUpdate)
import Modes.Insert exposing (insertModeUpdate)


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        KeyInput keyPress ->
            case model.mode of
                Insert ->
                    insertModeUpdate model keyPress

                Control ->
                    controlModeUpdate model keyPress

        KeyUp keyPress ->
            if keyPress == 27 then
                update (KeyInput 27) model
            else
                ( model, Cmd.none )
