module Modes.Visual exposing (visualModeUpdate)

import Dict exposing (Dict)
import Model exposing (..)
import Keyboard exposing (KeyCode)
import Char
import Mode exposing (Mode(..))
import History exposing (addHistory)
import Util.Search exposing (searchTo)
import Modes.Control exposing (controlModeUpdate)
import Util.ListUtils exposing (..)


-- TODO update all these


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
        -- moveCursor
        |> Dict.insert 'd' handleVisualCut
        |> Dict.insert 'x' handleVisualCut
        |> Dict.insert 'y' handleVisualCopy



-- TODO move the rest into another file


innerUpdate : Model -> KeyCode -> ( Model, Cmd msg )
innerUpdate model keyCode =
    case Dict.get (Char.fromCode keyCode) dict of
        Just theFunction ->
            theFunction model ! []

        Nothing ->
            ( model, Cmd.none )


handleVisualCut : Model -> Model
handleVisualCut model =
    let
        croppedTargetLines =
            getVisualCopyBuffer model
                |> Debug.log "Buffer to be"

        ( startX, startY, endX, endY ) =
            getStartAndEnd model

        startLines =
            model.lines
                |> List.take (startY + 1)
                |> List.reverse

        reversedStartLinesAfterMutation =
            mutateAtIndex 0 startLines (\line -> String.left startX line)

        endLines =
            model.lines
                |> List.drop endY

        endLinesAfterMutation =
            mutateAtIndex 0 endLines (\line -> String.dropLeft (endX + 1) line)

        combined =
            case endLinesAfterMutation of
                endHead :: endRest ->
                    case reversedStartLinesAfterMutation of
                        startHead :: startRest ->
                            (List.reverse startRest)
                                ++ [ startHead ++ endHead ]
                                ++ endRest

                        _ ->
                            endLinesAfterMutation

                _ ->
                    model.lines
    in
        { model | mode = Control, lines = combined, buffer = InlineBuffer croppedTargetLines }


getVisualCopyBuffer : Model -> List String
getVisualCopyBuffer model =
    let
        ( startX, startY, endX, endY ) =
            getStartAndEnd model

        fullTargetLines =
            model.lines
                |> List.drop startY
                |> List.take (endY - startY + 1)

        croppedTargetLines =
            case fullTargetLines of
                first :: second :: rest ->
                    let
                        updatedLine =
                            String.dropLeft startX first
                    in
                        updatedLine :: second :: rest

                single :: [] ->
                    let
                        updatedLine =
                            single
                                |> String.dropLeft startX
                                |> String.dropRight ((String.length single) - endX - 1)
                    in
                        [ updatedLine ]

                [] ->
                    fullTargetLines

        final =
            case List.reverse croppedTargetLines of
                first :: second :: rest ->
                    let
                        updatedLine =
                            first
                                |> String.left (endX + 1)
                    in
                        updatedLine
                            :: second
                            :: rest
                            |> List.reverse

                _ ->
                    croppedTargetLines
    in
        final


handleVisualCopy : Model -> Model
handleVisualCopy model =
    { model | mode = Control, buffer = InlineBuffer <| getVisualCopyBuffer model }


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
