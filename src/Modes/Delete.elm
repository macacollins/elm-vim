module Modes.Delete exposing (deleteModeUpdate)

import Model exposing (Model)
import Keyboard exposing (KeyCode)
import Mode exposing (Mode(Control, NavigateToCharacter), NavigationType(..))
import Delete.DeleteLines exposing (..)
import Delete.DeleteToCharacter exposing (deleteToCharacter)
import Delete.DeleteToEndOfLine exposing (..)
import Delete.DeleteToStartOfLine exposing (..)
import Delete.DeleteCharacter exposing (..)
import Delete.DeleteNavigationKeys exposing (..)
import Delete.DeleteWords exposing (..)
import Delete.DeleteToLine exposing (deleteToLineDefaultStart, deleteToLineDefaultEnd)
import History exposing (addHistory)
import Modes.Control exposing (controlModeUpdate)
import Char
import Dict exposing (Dict)
import Mode exposing (Mode(..))
import Macro.ActionEntry exposing (ActionEntry(..))
import Util.ModifierUtils exposing (getNumberModifier)


addLastCommand : ActionEntry -> Model -> Model
addLastCommand action model =
    { model | lastAction = action }


dict : Dict Char (Model -> Model)
dict =
    Dict.empty
        |> Dict.insert 'd' deleteLines
        |> Dict.insert 'w' deleteToNextWord
        |> Dict.insert 'b' deleteBackWords
        |> Dict.insert 'j' deleteDown
        |> Dict.insert 'k' deleteUp
        |> Dict.insert 'h' deleteLeft
        |> Dict.insert 'l' deleteRight
        |> Dict.insert '$' deleteToEndOfLine
        |> Dict.insert '0' deleteToStartOfLine
        |> Dict.insert 'G' deleteToLineDefaultEnd
        |> Dict.insert 'g' (\model -> { model | mode = Delete GoToLine })
        |> Dict.insert 't' (\model -> { model | mode = Delete (NavigateToCharacter Til) })
        |> Dict.insert 'f' (\model -> { model | mode = Delete (NavigateToCharacter To) })
        |> Dict.insert 'F' (\model -> { model | mode = Delete (NavigateToCharacter ToBack) })


deleteModeUpdate : Model -> KeyCode -> ( Model, Cmd msg )
deleteModeUpdate model keyCode =
    case model.mode of
        Delete Control ->
            deleteModeUpdateInner model keyCode

        Delete GoToLine ->
            if Char.fromCode keyCode == 'g' then
                deleteToLineDefaultStart model ! []
            else
                handleDefaultInput model keyCode

        Delete (NavigateToCharacter Til) ->
            deleteToCharacter model keyCode

        Delete (NavigateToCharacter To) ->
            deleteToCharacter model keyCode

        Delete (NavigateToCharacter ToBack) ->
            deleteToCharacter model keyCode

        -- TODO TilBack :/
        _ ->
            handleDefaultInput model keyCode


handleDefaultInput : Model -> KeyCode -> ( Model, Cmd msg )
handleDefaultInput model keyCode =
    if Char.isDigit (Char.fromCode keyCode) then
        controlModeUpdate model keyCode
    else
        { model | mode = Control } ! []


deleteModeUpdateInner : Model -> KeyCode -> ( Model, Cmd msg )
deleteModeUpdateInner model keyCode =
    case Dict.get (Char.fromCode keyCode) dict of
        Just handler ->
            let
                updatedModel =
                    (handler model |> addHistory model)

                newMode =
                    case updatedModel.mode of
                        Delete Control ->
                            Control

                        _ as other ->
                            other

                lastAction =
                    (toString <| getNumberModifier model) ++ "d" ++ (String.cons (Char.fromCode keyCode) "")
            in
                { updatedModel
                    | mode = newMode
                    , lastAction = Keys lastAction
                }
                    ! []

        Nothing ->
            handleDefaultInput model keyCode
