module Util.Search exposing (..)

import Util.ListUtils exposing (getLine)
import Model exposing (Model)


searchTo : String -> Model -> Maybe Model
searchTo searchString model =
    let
        { cursorX, cursorY } =
            model

        line =
            getLine cursorY model.lines

        indexes =
            String.indexes searchString line
                |> List.filter (\index -> index > model.cursorX)
    in
        case indexes of
            -- will have to make this smarter so that we can cycle entries
            head :: _ ->
                Just { model | cursorX = head }

            _ ->
                if model.cursorY == List.length model.lines then
                    Nothing
                else
                    searchTo searchString { model | cursorY = model.cursorY + 1, cursorX = 0 }


searchBackwards : String -> Model -> Maybe Model
searchBackwards searchString model =
    let
        { cursorX, cursorY } =
            model

        line =
            getLine cursorY model.lines

        indexes =
            String.indexes searchString line
                |> List.filter (\index -> index < model.cursorX)
                |> List.reverse
    in
        case indexes of
            -- will have to make this smarter so that we can cycle entries
            head :: _ ->
                Just { model | cursorX = head }

            _ ->
                if model.cursorY == 0 then
                    Nothing
                else
                    { model
                        | cursorY = model.cursorY - 1
                        , cursorX = String.length (getLine (model.cursorY - 1) model.lines)
                    }
                        |> searchBackwards searchString
