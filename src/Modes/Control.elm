module Modes.Control exposing (controlModeUpdate)

import Model exposing (..)
import Keyboard exposing (KeyCode)
import List exposing (..)
import Dict exposing (Dict)
import Char
import Mode exposing (Mode(..))
import Handlers.DeleteCharacter exposing (..)
import Handlers.ScreenMovement exposing (..)
import Handlers.Delete exposing (..)
import Handlers.Undo exposing (..)
import Handlers.Redo exposing (..)
import Handlers.Paste exposing (..)
import Handlers.Yank exposing (..)
import Handlers.Navigation exposing (..)
import Handlers.PreviousWord exposing (..)
import Handlers.NextWord exposing (..)
import Handlers.JoinLines exposing (joinLines)
import Handlers.NavigateFile exposing (..)
import Handlers.NextSearchResult exposing (..)
import Handlers.LastSearchResults exposing (..)
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
        |> Dict.insert 'w' handleW
        |> Dict.insert 'H' moveToTopOfScreen
        |> Dict.insert 'L' moveToBottomOfScreen
        |> Dict.insert 'M' moveToMiddleOfScreen
        -- text manipulation
        |> Dict.insert 'J' joinLines
        |> Dict.insert 'd' handleD
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
        |> Dict.insert 'y' handleY
        |> Dict.insert '0' handle0
        |> Dict.insert 'G' handleG
        |> Dict.insert 'g' handleLittleG
        |> Dict.insert '$' handleDollar
        |> Dict.insert 'u' handleU
        |> Dict.insert 'R' handleR
        |> Dict.insert 'X' handleBackspace
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


handle0 model =
    if List.length (List.filter Char.isDigit model.inProgress) > 0 then
        { model | inProgress = '0' :: model.inProgress }
    else
        { model | cursorX = 0 }


handleDollar model =
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
