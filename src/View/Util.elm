module View.Util exposing (..)

import Model exposing (Model)


getActualScreenWidth : Model -> Int
getActualScreenWidth model =
    let
        additionalFromNumbers =
            if model.properties.lineNumbers then
                List.length model.lines
                    |> toString
                    |> String.length
            else if model.properties.relativeLineNumbers then
                4
            else
                0
    in
        model.windowWidth - additionalFromNumbers - 2
