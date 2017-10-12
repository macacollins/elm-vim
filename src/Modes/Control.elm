module Modes.Control exposing (controlModeUpdate)

import Model exposing (..)
import Keyboard exposing (KeyCode)
import List exposing (..)
import Dict exposing (Dict)
import Char
import Mode exposing (Mode(..))
import Delete.DeleteCharacter exposing (..)
import Control.ScreenMovement exposing (..)
import Delete.Delete exposing (..)
import Control.Undo exposing (..)
import Control.Redo exposing (..)
import Control.Paste exposing (..)
import Yank.Yank exposing (..)
import Control.Navigation exposing (..)
import Control.PreviousWord exposing (..)
import Control.NextWord exposing (..)
import Control.JoinLines exposing (joinLines)
import Control.NavigateFile exposing (..)
import Control.NextSearchResult exposing (..)
import Control.LastSearchResults exposing (..)
import Delete.DeleteToEndOfLine exposing (..)
import Util.ListUtils exposing (..)
import History exposing (addHistory)


-- TODO need to make this configurable


dict : Dict Char (Model -> Model)
dict =
    Dict.empty
        -- moveCursor
        |> Dict.insert 'l' handleRight
        |> Dict.insert 'h' handleLeft
        |> Dict.insert 'j' handleDown
        |> Dict.insert 'k' handleUp
        |> Dict.insert 'b' handleB
        |> Dict.insert 'w' navigateToNextWord
        |> Dict.insert 'H' moveToTopOfScreen
        |> Dict.insert 'L' moveToBottomOfScreen
        |> Dict.insert 'M' moveToMiddleOfScreen
        -- text manipulation
        |> Dict.insert 'J' joinLines
        |> Dict.insert 'D' deleteToEndOfLine
        |> Dict.insert 'i' (\model -> addHistory model { model | mode = Insert })
        |> Dict.insert 'q' (\model -> { model | mode = Macro Control })
        |> Dict.insert '@' (\model -> { model | mode = MacroExecute })
        |> Dict.insert 'x' (\model -> addHistory model <| handleX model)
        |> Dict.insert 'n' (\model -> handleN model)
        |> Dict.insert 'N' handleCapitalN
        |> Dict.insert 'O' handleO
        |> Dict.insert 'o' handleo
        |> Dict.insert 'p' (\model -> addHistory model <| handlePaste model)
        |> Dict.insert 'P' (\model -> addHistory model <| handlePasteBefore model)
        |> Dict.insert '0' handle0
        |> Dict.insert 'G' handleG
        |> Dict.insert 'g' handleLittleG
        |> Dict.insert '$' navigateToEndOfLine
        |> Dict.insert 'u' handleU
        |> Dict.insert 'R' handleR
        |> Dict.insert 'X' handleBackspace
        |> Dict.insert 'y' (\model -> { model | mode = Yank })
        |> Dict.insert 'd' (\model -> { model | mode = Delete })
        |> Dict.insert 'v' (\model -> { model | mode = Visual model.cursorX model.cursorY })
        |> Dict.insert '/' (\model -> { model | mode = Search })


controlModeUpdate : Model -> KeyCode -> ( Model, Cmd msg )
controlModeUpdate model keyCode =
    let
        default =
            if 48 <= keyCode && keyCode <= 57 then
                { model | inProgress = (Char.fromCode keyCode) :: model.inProgress }
            else
                model

        newModel =
            case Dict.get (Char.fromCode keyCode) dict of
                Just theFunction ->
                    theFunction model

                Nothing ->
                    default
    in
        ( newModel, Cmd.none )


addHistory : Model -> Model -> Model
addHistory lastModel newModel =
    { newModel | pastStates = getState lastModel :: lastModel.pastStates }


handleO model =
    let
        updatedLines =
            insertAtIndex (model.cursorY) model.lines ""
    in
        addHistory model
            { model
                | mode = Insert
                , lines = updatedLines
                , cursorX = 0
            }


handleo model =
    let
        newCursorY =
            model.cursorY + 1

        updatedLines =
            insertAtIndex (model.cursorY + 1) model.lines ""
    in
        addHistory model
            { model
                | mode = Insert
                , cursorY = newCursorY
                , cursorX = 0
                , lines = updatedLines
            }


handle0 : Model -> Model
handle0 model =
    if List.length (List.filter Char.isDigit model.inProgress) > 0 then
        { model | inProgress = '0' :: model.inProgress }
    else
        { model | cursorX = 0 }


navigateToEndOfLine : Model -> Model
navigateToEndOfLine model =
    let
        length =
            String.length <| getLine model.cursorY model.lines

        zeroSafeLength =
            if length == 0 then
                0
            else
                length - 1
    in
        { model | cursorX = zeroSafeLength }
