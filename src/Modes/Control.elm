module Modes.Control exposing (controlModeUpdate)

import Model exposing (..)
import Keyboard exposing (KeyCode)
import Dict exposing (Dict)
import Macro.ActionEntry exposing (ActionEntry(..))
import Char
import Mode exposing (Mode(..), NavigationType(..))
import Delete.DeleteCharacter exposing (..)
import Constants
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
import Control.MoveToStartOfLine exposing (..)
import Control.MoveToEndOfLine exposing (..)
import Control.MoveToEndOfWord exposing (..)
import Control.InsertLineAboveCursor exposing (..)
import Control.InsertLineBelowCursor exposing (..)
import Yank.YankLines exposing (..)
import Delete.DeleteToEndOfLine exposing (..)
import Util.ListUtils exposing (..)
import History exposing (addHistory)


controlModeUpdate : Model -> KeyCode -> ( Model, Cmd msg )
controlModeUpdate model keyCode =
    let
        keyChar =
            Char.fromCode keyCode

        default =
            if 48 <= keyCode && keyCode <= 57 then
                { model | numberBuffer = keyChar :: model.numberBuffer }
            else
                case Dict.get keyChar modeDict of
                    Just newMode ->
                        -- TODO more thoroughly test the history here
                        addHistory model { model | mode = newMode }

                    Nothing ->
                        model

        newModel =
            case Dict.get keyChar dict of
                Just theFunction ->
                    theFunction model

                Nothing ->
                    default
    in
        ( newModel, Cmd.none )


dict : Dict Char (Model -> Model)
dict =
    Dict.empty
        -- moveCursor
        |> Dict.insert 'l' moveRight
        |> Dict.insert 'h' moveLeft
        |> Dict.insert 'j' moveDown
        |> Dict.insert 'k' moveUp
        |> Dict.insert Constants.rightArrowKeyChar moveRight
        |> Dict.insert Constants.leftArrowKeyChar moveLeft
        |> Dict.insert Constants.downArrowKeyChar moveDown
        |> Dict.insert Constants.upArrowKeyChar moveUp
        |> Dict.insert 'e' moveToEndOfWord
        |> Dict.insert 'b' moveToLastWord
        |> Dict.insert 'w' moveToNextWord
        |> Dict.insert 'H' moveToTopOfScreen
        |> Dict.insert 'L' moveToBottomOfScreen
        |> Dict.insert 'M' moveToMiddleOfScreen
        |> Dict.insert '0' moveToStartOfLine
        |> Dict.insert '$' moveToEndOfLine
        |> Dict.insert 'G' goToLine
        |> Dict.insert 'A' appendAtEnd
        |> Dict.insert 'I' appendAtStart
        -- text manipulation
        |> Dict.insert 'J' joinLines
        |> Dict.insert 'D' deleteToEndOfLine
        |> Dict.insert 'C' cutToEndOfLine
        |> Dict.insert 'X' handleBackspace
        |> Dict.insert (Char.fromCode 8) handleBackspace
        |> Dict.insert 's' substitute
        |> Dict.insert 'S' substituteLine
        -- search
        |> Dict.insert 'n' moveToNextSearchResult
        |> Dict.insert 'N' moveToLastSearchResult
        -- insert new line
        |> Dict.insert 'O' insertLineAboveCursor
        |> Dict.insert 'o' insertLineBelowCursor
        -- undo, redo
        |> Dict.insert 'u' handleUndo
        |> Dict.insert 'R' handleRedo
        -- Yank shortcut
        |> Dict.insert 'Y' yankLines
        -- switch modes
        |> Dict.insert 'v' (\model -> { model | mode = Visual model.cursorX model.cursorY })
        -- TODO move the addHistory into the functions themselves
        |> Dict.insert 'p' (\model -> addHistory model <| handlePaste model)
        |> Dict.insert 'P' (\model -> addHistory model <| handlePasteBefore model)
        |> Dict.insert 'x' (\model -> addHistory model <| deleteCharacterUnderCursor model)
        |> Dict.insert 'a' enterAppendMode


cutToEndOfLine : Model -> Model
cutToEndOfLine =
    deleteToEndOfLine
        >> moveToEndOfLine
        >> enterAppendMode
        >> setLastAction (Keys "C")


setLastAction : ActionEntry -> Model -> Model
setLastAction entry model =
    { model | lastAction = entry }


modeDict : Dict Char Mode
modeDict =
    Dict.empty
        |> Dict.insert 'y' (Yank Control)
        |> Dict.insert 'd' (Delete Control)
        |> Dict.insert '/' Search
        |> Dict.insert ':' (Command ":")
        |> Dict.insert '@' MacroExecute
        |> Dict.insert 'q' EnterMacroName
        |> Dict.insert 'i' Insert
        |> Dict.insert 'c' ChangeText
        |> Dict.insert 'g' GoToLine
        |> Dict.insert 't' (NavigateToCharacter Til)
        |> Dict.insert 'T' (NavigateToCharacter TilBack)
        |> Dict.insert 'F' (NavigateToCharacter ToBack)
        |> Dict.insert 'f' (NavigateToCharacter To)
