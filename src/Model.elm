module Model exposing (PasteBuffer(..), Model, State, getState, initialModel)

import Macro.ActionEntry exposing (ActionEntry(..))
import Mode exposing (Mode(..))
import Macro.Model exposing (MacroModel, initialMacroModel)
import Properties exposing (Properties, defaultProperties)
import Drive exposing (DriveState)


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
    , windowHeight : Int
    , lastAction : ActionEntry

    -- Computed property with the # of logical lines displayed on the screen
    -- We need this in order to handle line wraps
    , linesShown : Int
    , windowWidth : Int
    , properties : Properties

    -- TODO probably move this into the StorageMethod type
    , driveState : DriveState
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
    , lastAction = Keys ""
    , firstLine = 0
    , pastStates = []
    , futureStates = []
    , searchString = ""
    , searchStringBuffer = ""
    , macroModel = initialMacroModel
    , windowHeight = 31
    , windowWidth = 80
    , properties = defaultProperties
    , linesShown = 31
    , driveState = Drive.defaultDriveState
    }
