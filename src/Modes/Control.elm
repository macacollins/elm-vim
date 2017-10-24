module Modes.Control exposing (controlModeUpdate)

import Model exposing (..)
import Keyboard exposing (KeyCode)
import List exposing (..)
import Dict exposing (Dict)
import Char
import Mode exposing (Mode(..), NavigationType(..))
import Delete.DeleteCharacter exposing (..)
import Control.ScreenMovement exposing (..)
import Control.Undo exposing (..)
import Control.Redo exposing (..)
import Control.Substitute exposing (substitute)
import Control.Paste exposing (..)
import Control.Move exposing (..)
import Control.AppendAtEnd exposing (..)
import Control.AppendAtStart exposing (..)
import Control.SubstituteLine exposing (..)
import Control.PreviousWord exposing (..)
import Control.EnterAppendMode exposing (..)
import Control.NextWord exposing (..)
import Control.JoinLines exposing (joinLines)
import Control.NavigateFile exposing (..)
import Control.NextSearchResult exposing (..)
import Control.LastSearchResults exposing (..)
import Yank.YankLines exposing (..)
import Delete.DeleteToEndOfLine exposing (..)
import Util.ListUtils exposing (..)
import History exposing (addHistory)


dict : Dict Char (Model -> Model)
dict =
    Dict.empty
        -- moveCursor
        -- TODO standardize on handle, navigate, or move
        |> Dict.insert 'l' moveRight
        |> Dict.insert 'h' moveLeft
        |> Dict.insert 'j' moveDown
        |> Dict.insert 'k' moveUp
        |> Dict.insert 'b' navigateToLastWord
        |> Dict.insert 'w' navigateToNextWord
        |> Dict.insert 'H' moveToTopOfScreen
        |> Dict.insert 'L' moveToBottomOfScreen
        |> Dict.insert 'M' moveToMiddleOfScreen
        |> Dict.insert '0' navigateToStartOfLine
        |> Dict.insert '$' navigateToEndOfLine
        |> Dict.insert 'G' handleG
        |> Dict.insert 'A' appendAtEnd
        |> Dict.insert 'I' appendAtStart
        -- text manipulation
        |> Dict.insert 'J' joinLines
        |> Dict.insert 'D' deleteToEndOfLine
        |> Dict.insert 'X' handleBackspace
        |> Dict.insert 's' substitute
        |> Dict.insert 'S' substituteLine
        -- search
        |> Dict.insert 'n' navigateToNextSearchResult
        |> Dict.insert 'N' navigateToLastSearchResult
        -- insert new line
        |> Dict.insert 'O' handleO
        |> Dict.insert 'o' handleo
        -- undo, redo
        |> Dict.insert 'u' handleUndo
        |> Dict.insert 'R' handleRedo
        -- switch modes
        |> Dict.insert 'v' (\model -> { model | mode = Visual model.cursorX model.cursorY })
        -- TODO move the addHistory into the functions themselves
        |> Dict.insert 'p' (\model -> addHistory model <| handlePaste model)
        |> Dict.insert 'P' (\model -> addHistory model <| handlePasteBefore model)
        |> Dict.insert 'x' (\model -> addHistory model <| deleteCharacterUnderCursor model)
        |> Dict.insert 'a' enterAppendMode


modeDict : Dict Char Mode
modeDict =
    Dict.empty
        |> Dict.insert 'y' (Yank Control)
        |> Dict.insert 'd' (Delete Control)
        |> Dict.insert '/' Search
        |> Dict.insert ':' (Command ":")
        |> Dict.insert '@' MacroExecute
        |> Dict.insert 'q' (Macro Control)
        |> Dict.insert 'i' Insert
        |> Dict.insert 'g' GoToLine
        |> Dict.insert 't' (NavigateToCharacter Til)
        |> Dict.insert 'T' (NavigateToCharacter TilBack)
        |> Dict.insert 'f' (NavigateToCharacter To)
        |> Dict.insert 'F' (NavigateToCharacter ToBack)


controlModeUpdate : Model -> KeyCode -> ( Model, Cmd msg )
controlModeUpdate model keyCode =
    let
        default =
            if 48 <= keyCode && keyCode <= 57 then
                { model | numberBuffer = (Char.fromCode keyCode) :: model.numberBuffer }
            else
                case Dict.get (Char.fromCode keyCode) modeDict of
                    Just newMode ->
                        -- TODO more thoroughly test the history here
                        addHistory model { model | mode = newMode }

                    Nothing ->
                        model

        newModel =
            case Dict.get (Char.fromCode keyCode) dict of
                Just theFunction ->
                    theFunction model

                Nothing ->
                    default
    in
        ( newModel, Cmd.none )



-- TODO move the rest of these to their own files


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


navigateToStartOfLine : Model -> Model
navigateToStartOfLine model =
    if List.length (List.filter Char.isDigit model.numberBuffer) > 0 then
        { model | numberBuffer = '0' :: model.numberBuffer }
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
