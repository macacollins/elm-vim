module Modes.Search exposing (searchModeUpdate)

import Model exposing (..)
import Keyboard exposing (KeyCode)
import Char
import Mode exposing (Mode(..))
import History exposing (addHistory)
import Util.Search exposing (searchTo)


searchModeUpdate : Model -> KeyCode -> ( Model, Cmd msg )
searchModeUpdate model keyCode =
    let
        theChar =
            (Char.fromCode keyCode)

        updatedSearchString =
            model.searchStringBuffer
                ++ String.cons theChar ""

        updatedModel =
            if keyCode == 13 then
                case searchTo model.searchStringBuffer model of
                    Just updatedModel ->
                        { updatedModel
                            | mode = Control
                            , searchString = model.searchStringBuffer
                            , searchStringBuffer = ""
                        }

                    Nothing ->
                        { model
                            | mode = Control
                            , searchString = model.searchStringBuffer
                            , searchStringBuffer = ""
                        }
            else if keyCode == 27 then
                { model | mode = Control }
            else
                { model | searchStringBuffer = updatedSearchString }
    in
        updatedModel ! []
