module Delete.DeleteToCharacter exposing (deleteToCharacter)

import Model exposing (Model, PasteBuffer(..))
import Util.ListUtils exposing (mutateAtIndex, getLine)
import Keyboard exposing (KeyCode)
import Modes.NavigateToCharacter exposing (navigateToCharacterModeUpdate)
import Mode exposing (Mode(..))


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
            { model | mode = Control }
                ! []
        else
            { model
                | lines = updatedLines
                , buffer = finalBuffer
                , numberBuffer = []
                , mode = Control
                , cursorX = low
            }
                ! []
