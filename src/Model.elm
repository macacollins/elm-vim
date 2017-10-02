module Model exposing (PasteBuffer(..), Model, State, getState, initialModel)

import Mode exposing (Mode(..))
import Macro.Model exposing (MacroModel, initialMacroModel)


type alias Model =
    { lines : List String
    , cursorX : Int
    , cursorY : Int
    , mode : Mode
    , inProgress : List Char
    , buffer : PasteBuffer
    , firstLine : Int
    , pastStates : List State
    , futureStates : List State
    , searchString : String
    , searchStringBuffer : String
    , macroModel : MacroModel
    , screenHeight : Int
    }


type alias State =
    { lines : List String
    , cursorX : Int
    , cursorY : Int
    , firstLine : Int
    }


type PasteBuffer
    = LinesBuffer (List String)
    | InlineBuffer (List String)


getState : Model -> State
getState model =
    State
        model.lines
        model.cursorX
        model.cursorY
        model.firstLine



-- TODO move this to the other syntax with named params


initialModel =
    Model
        (List.repeat 1 "")
        0
        0
        Control
        []
        (LinesBuffer [])
        0
        []
        []
        ""
        ""
        initialMacroModel
        30
