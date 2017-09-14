module Actions exposing (ActionEntry(..), newStateAfterActions)

import Char
import Keyboard exposing (KeyCode)
import Update exposing (update)
import Msg exposing (Msg(..))
import Model exposing (Model, initialModel)
import List exposing (repeat)
import Mode exposing (Mode(..))


type ActionEntry
    = Enter
    | Escape
    | Backspace
    | Keys String


newStateAfterActions : List ActionEntry -> Model
newStateAfterActions entries =
    applyActions initialModel entries


applyActions : Model -> List ActionEntry -> Model
applyActions model actions =
    List.foldl enterKeySequence model actions


enterKeySequence : ActionEntry -> Model -> Model
enterKeySequence actionEntry model =
    let
        codes =
            getCodeList actionEntry

        applyKey : KeyCode -> Model -> Model
        applyKey code model =
            let
                ( newModel, _ ) =
                    update (KeyInput code) model
            in
                newModel
    in
        List.foldr applyKey model codes


getCodeList : ActionEntry -> List KeyCode
getCodeList actionEntry =
    case actionEntry of
        Enter ->
            [ 13 ]

        Escape ->
            [ 27 ]

        Backspace ->
            [ 8 ]

        Keys keys ->
            let
                addCodeAndRecur : Char -> List KeyCode -> List KeyCode
                addCodeAndRecur character resultList =
                    Char.toCode character :: resultList
            in
                String.foldl addCodeAndRecur [] keys
