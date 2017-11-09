module Delete.DeleteToCharacter exposing (deleteToCharacter)

import Model exposing (Model, PasteBuffer(..))
import Util.ListUtils exposing (mutateAtIndex, getLine)
import Keyboard exposing (KeyCode)
import Macro.ActionEntry exposing (ActionEntry(..))
import Char
import Modes.NavigateToCharacter exposing (navigateToCharacterModeUpdate)
import Mode exposing (Mode(..), NavigationType(..))


-- mutateAtIndex : Int -> List a -> (a -> a) -> List a


deleteToCharacter : Model -> KeyCode -> ( Model, Cmd msg )
deleteToCharacter model keyCode =
    let
        innerMode =
            case model.mode of
                Delete (_ as mode) ->
                    mode

                _ ->
                    Delete Control

        newLastAction =
            case innerMode of
                NavigateToCharacter Til ->
                    Keys <| "dt" ++ (String.cons (Char.fromCode keyCode) "")

                NavigateToCharacter To ->
                    Keys <| "df" ++ (String.cons (Char.fromCode keyCode) "")

                NavigateToCharacter ToBack ->
                    Keys <| "dF" ++ (String.cons (Char.fromCode keyCode) "")

                NavigateToCharacter TilBack ->
                    Keys <| "dT" ++ (String.cons (Char.fromCode keyCode) "")

                _ ->
                    Keys ""

        { cursorX, cursorY, lines } =
            model

        modelWithInnerMode =
            { model | mode = innerMode }

        ( navigateModeUpdatedModel, _ ) =
            navigateToCharacterModeUpdate modelWithInnerMode keyCode

        newCursorX =
            navigateModeUpdatedModel.cursorX

        ( low, high ) =
            if cursorX < newCursorX then
                ( cursorX, newCursorX + 1 )
            else
                ( newCursorX, cursorX )

        updatedLines =
            mutateAtIndex cursorY lines (\line -> String.left low line ++ String.dropLeft high line)

        updatedBuffer =
            getLine cursorY lines
                |> String.dropLeft low
                |> String.left (high - low)
                |> List.singleton
                |> InlineBuffer

        finalBuffer =
            if updatedBuffer == InlineBuffer [ "" ] then
                -- default empty buffer
                -- we should prolly express this at a type level instead of as a convention
                LinesBuffer []
            else
                updatedBuffer
    in
        if cursorX == newCursorX then
            { model
                | mode = Control
                , lastAction = Keys ""
            }
                ! []
        else
            { model
                | lines = updatedLines
                , buffer = finalBuffer
                , numberBuffer = []
                , mode = Control
                , cursorX = low
                , lastAction = newLastAction
            }
                ! []
