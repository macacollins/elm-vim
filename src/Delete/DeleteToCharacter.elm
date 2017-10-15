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

        updatedLines =
            mutateAtIndex cursorY lines (\line -> String.left (cursorX) line ++ String.dropLeft (newCursorX + 1) line)

        updatedBuffer =
            getLine cursorY lines
                |> String.dropLeft cursorX
                |> String.left (newCursorX - cursorX + 1)
                |> List.singleton
                |> InlineBuffer
    in
        if cursorX == newCursorX then
            { model | mode = Control }
                ! []
        else
            { model
                | lines = updatedLines
                , buffer = updatedBuffer
                , cursorX = 0
                , inProgress = []
                , mode = Control
            }
                ! []
