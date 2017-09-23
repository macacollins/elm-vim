module Update exposing (update)

import Char
import Msg exposing (Msg(..))
import Model exposing (Model)
import Mode exposing (Mode(..))
import Modes.Control exposing (controlModeUpdate)
import Modes.Insert exposing (insertModeUpdate)
import Modes.Search exposing (searchModeUpdate)
import Modes.MacroRecord exposing (macroRecordModeUpdate)
import Keyboard exposing (KeyCode)


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        KeyInput keyPress ->
            updateKeyInput keyPress model.mode model

        KeyUp keyPress ->
            if List.member keyPress [ 27, 8 ] then
                update (KeyInput keyPress) model
            else if List.member keyPress [ 37, 38, 39, 40 ] then
                controlModeUpdate model <| translateArrowKeys keyPress
            else
                ( model, Cmd.none )


updateKeyInput : KeyCode -> Mode -> Model -> ( Model, Cmd msg )
updateKeyInput keyPress mode model =
    case mode of
        Insert ->
            insertModeUpdate model keyPress

        Control ->
            controlModeUpdate model keyPress

        Search ->
            searchModeUpdate model keyPress

        Macro inner ->
            let
                -- future bug if we start returning cmds
                -- this could impact performance if we are calculating a model we won't use
                ( newModel, _ ) =
                    updateKeyInput keyPress inner model

                initialModel =
                    model
            in
                -- consider re-ordering this
                macroRecordModeUpdate newModel initialModel keyPress


translateArrowKeys input =
    if input == 37 then
        104
    else if input == 38 then
        107
    else if input == 39 then
        108
    else if input == 40 then
        106
    else
        0
