module Actions exposing (ActionEntry(..), newStateAfterActions)

import Char
import Keyboard exposing (KeyCode)
import Update exposing (update)
import Msg exposing (Msg(..))
import Model exposing (Model)
import Array exposing (fromList, repeat)
import Mode exposing (Mode(..))


type ActionEntry
    = Enter
    | Escape
    | Keys String


newStateAfterActions : List ActionEntry -> Model
newStateAfterActions entries =
    applyActions (initialModel [ "" ]) entries


applyActions : Model -> List ActionEntry -> Model
applyActions model actions =
    List.foldl enterKeySequence model actions


enterKeySequence : ActionEntry -> Model -> Model
enterKeySequence actionEntry model =
    let
        codes =
            getCodeArray actionEntry

        applyKey : KeyCode -> Model -> Model
        applyKey code model =
            let
                ( newModel, _ ) =
                    update (KeyInput code) model
            in
                newModel
    in
        List.foldr applyKey model codes


getCodeArray : ActionEntry -> List KeyCode
getCodeArray actionEntry =
    case actionEntry of
        Enter ->
            [ 13 ]

        Escape ->
            [ 27 ]

        Keys keys ->
            let
                addCodeAndRecur : Char -> List KeyCode -> List KeyCode
                addCodeAndRecur character resultArray =
                    Char.toCode character :: resultArray
            in
                String.foldl addCodeAndRecur [] keys


initialModel lines =
    Debug.log "Getting the model." <|
        Model
            (Array.fromList
                lines
            )
            0
            0
            Control
            []
