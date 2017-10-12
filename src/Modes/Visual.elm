module Modes.Visual exposing (visualModeUpdate)

import Dict exposing (Dict)
import Model exposing (..)
import Keyboard exposing (KeyCode)
import Char
import Mode exposing (Mode(..))
import Modes.Control exposing (controlModeUpdate)
import Control.CutSegment exposing (cutSegment)
import Yank.CopySegment exposing (getSegmentCopyBuffer)


visualModeUpdate : Model -> KeyCode -> ( Model, Cmd msg )
visualModeUpdate model keyCode =
    let
        code =
            Char.fromCode keyCode

        triggerControlUpdate =
            List.member code [ 'w', 'b', 'j', 'k', 'l', 'h', 'g', 'G', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0' ]
    in
        if triggerControlUpdate then
            controlModeUpdate model keyCode
        else
            innerUpdate model keyCode


dict : Dict Char (Model -> Model)
dict =
    Dict.empty
        |> Dict.insert 'd' cutSegment
        |> Dict.insert 'x' cutSegment
        |> Dict.insert 'y' handleVisualCopy


innerUpdate : Model -> KeyCode -> ( Model, Cmd msg )
innerUpdate model keyCode =
    case Dict.get (Char.fromCode keyCode) dict of
        Just theFunction ->
            theFunction model ! []

        Nothing ->
            ( model, Cmd.none )


handleVisualCopy : Model -> Model
handleVisualCopy model =
    { model | mode = Control, buffer = InlineBuffer <| getSegmentCopyBuffer model }
