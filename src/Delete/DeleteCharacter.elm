module Delete.DeleteCharacter exposing (deleteCharacterUnderCursor, handleBackspace)

import Model exposing (Model)
import List
import Util.ListUtils exposing (..)


deleteCharacterUnderCursor : Model -> Model
deleteCharacterUnderCursor model =
    let
        { lines, cursorY, cursorX } =
            model

        updateLine currentLine =
            (String.slice 0 cursorX currentLine)
                ++ (String.slice
                        (cursorX + 1)
                        (String.length currentLine)
                        currentLine
                   )

        finalLines =
            mutateAtIndex cursorY lines updateLine

        mutatedLine =
            getLine cursorY finalLines

        finalCursorX =
            if cursorX < String.length mutatedLine then
                cursorX
            else if String.length mutatedLine == 0 then
                0
            else
                String.length mutatedLine - 1
    in
        { model | lines = finalLines, cursorX = finalCursorX }


handleBackspace : Model -> Model
handleBackspace model =
    case model.cursorX of
        0 ->
            handleBackspaceLine model

        _ ->
            navigateToNextSearchResultormalBackspace model


navigateToNextSearchResultormalBackspace : Model -> Model
navigateToNextSearchResultormalBackspace model =
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
