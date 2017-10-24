module Model exposing (PasteBuffer(..), Model, State, getState, initialModel)

import Mode exposing (Mode(..))
import Macro.Model exposing (MacroModel, initialMacroModel)
import Properties exposing (Properties, defaultProperties)


type alias Model =
    { lines : List String
    , cursorX : Int
    , cursorY : Int
    , mode : Mode
    , numberBuffer : List Char
    , buffer : PasteBuffer
    , firstLine : Int
    , pastStates : List State
    , futureStates : List State
    , searchString : String
    , searchStringBuffer : String
    , macroModel : MacroModel
    , screenHeight : Int
    , properties : Properties
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


initialModel =
    { lines = (List.repeat 1 "")
    , cursorX = 0
    , cursorY = 0
    , mode = Control
    , numberBuffer = []
    , buffer = (LinesBuffer [])
    , firstLine = 0
    , pastStates = []
    , futureStates = []
    , searchString = ""
    , searchStringBuffer = ""
    , macroModel = initialMacroModel
    , screenHeight = 31
    , properties = defaultProperties
    }
