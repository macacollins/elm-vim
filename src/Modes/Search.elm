module Modes.Search exposing (searchModeUpdate)

import Model exposing (..)
import Keyboard exposing (KeyCode)
import List exposing (..)
import Char
import Mode exposing (Mode(..))
import Util.ListUtils exposing (..)
import History exposing (addHistory)


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
                        -- TODO probably restructure
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


searchTo : String -> Model -> Maybe Model
searchTo searchString model =
    let
        { cursorX, cursorY } =
            model

        line =
            getLine cursorY model.lines

        indexes =
            String.indexes searchString line
    in
        case indexes of
            -- will have to make this smarter so that we can cycle entries
            head :: _ ->
                Just { model | cursorX = head }

            _ ->
                if model.cursorY == List.length model.lines then
                    Nothing
                else
                    searchTo searchString { model | cursorY = model.cursorY + 1 }
