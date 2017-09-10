module Handlers.DeleteCharacter exposing (handleX, handleBackspace)

import Model exposing (Model)
import List
import Util.ListUtils exposing (..)


handleX : Model -> Model
handleX model =
    let
        { lines, cursorY, cursorX } =
            model

        updateLine currentLine =
            (String.slice 0 cursorX currentLine) ++ (String.slice (cursorX + 1) (String.length currentLine) currentLine)

        finalLines =
            mutateAtIndex cursorY lines updateLine
    in
        { model | lines = finalLines }


handleBackspace : Model -> Model
handleBackspace model =
    case model.cursorX of
        0 ->
            handleBackspaceLine model

        _ ->
            handleNormalBackspace model


handleNormalBackspace : Model -> Model
handleNormalBackspace model =
    let
        { lines, cursorY, cursorX } =
            model

        updateLine currentLine =
            (String.slice 0 (cursorX - 1) currentLine) ++ (String.slice cursorX (String.length currentLine) currentLine)

        finalLines =
            mutateAtIndex cursorY lines updateLine

        newCursorX =
            if finalLines == model.lines then
                cursorX
            else
                cursorX - 1
    in
        { model | lines = finalLines, cursorX = newCursorX }


handleBackspaceLine : Model -> Model
handleBackspaceLine model =
    let
        { cursorY } =
            model

        ( withLineRemoved, removedLine ) =
            removeAtIndex model.cursorY model.lines

        transform line =
            case removedLine of
                Just justLine ->
                    Debug.log "concatting!" <|
                        line
                            ++ justLine

                Nothing ->
                    Debug.log "removed line was Nothing." <|
                        line

        updatedLines =
            mutateAtIndex (model.cursorY - 1) withLineRemoved transform

        newCursorY =
            if cursorY == 0 then
                0
            else
                cursorY - 1

        newCursorX =
            String.length <| getLine newCursorY model.lines
    in
        if cursorY == 0 then
            model
        else
            { model
                | lines = updatedLines
                , cursorY = newCursorY
                , cursorX = newCursorX
            }
