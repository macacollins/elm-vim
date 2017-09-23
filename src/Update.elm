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


-- the below should get refactored

import Macro.ActionEntry exposing (ActionEntry(..))
import Macro.Model exposing (getMacro)


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

        MacroExecute ->
            -- not sure how to do this without introducing a circular reference :D
            macroExecuteModeUpdate model keyPress

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


macroExecuteModeUpdate : Model -> KeyCode -> ( Model, Cmd msg )
macroExecuteModeUpdate model keyPress =
    let
        targetMacro =
            getMacro
                (Char.fromCode keyPress)
                model.macroModel
    in
        applyActions { model | mode = Control } targetMacro ! []



-- WARNING!!! The below is copy / pasted from Actions. need to fix it up


applyActions : Model -> List ActionEntry -> Model
applyActions model actions =
    List.foldl enterKeySequence model actions


enterKeySequence : ActionEntry -> Model -> Model
enterKeySequence actionEntry model =
    let
        codes =
            getCodeList actionEntry

        applyKey : KeyCode -> Model -> Model
        applyKey code model =
            let
                ( newModel, _ ) =
                    update (KeyInput code) model
            in
                newModel
    in
        List.foldr applyKey model codes


getCodeList : ActionEntry -> List KeyCode
getCodeList actionEntry =
    case actionEntry of
        Enter ->
            [ 13 ]

        Escape ->
            [ 27 ]

        Backspace ->
            [ 8 ]

        Keys keys ->
            let
                addCodeAndRecur : Char -> List KeyCode -> List KeyCode
                addCodeAndRecur character resultList =
                    Char.toCode character :: resultList
            in
                String.foldl addCodeAndRecur [] keys
