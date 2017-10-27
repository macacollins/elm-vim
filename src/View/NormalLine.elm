module View.NormalLine exposing (getNormalLineHTML)

import Model exposing (Model)
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Attributes exposing (property, attribute)
import View.RenderLineWithCursor exposing (renderLineWithCursor)
import Mode exposing (Mode(..))
import View.VisualLine exposing (getVisualTextContents)
import View.Line exposing (Line(..), tildeLine)
import View.Util exposing (getActualScreenWidth)


getNormalLineHTML : Model -> Line -> Html msg
getNormalLineHTML model line =
    case line of
        TextLine lineNumber text ->
            getNormalLineInner model lineNumber text

        WrappedLine lineNumber numberWrapped text ->
            getWrappedLine model lineNumber numberWrapped text

        TildeLine ->
            tildeLine


getWrappedLine : Model -> Int -> Int -> String -> Html msg
getWrappedLine model index numberWrapped line =
    let
        textContents =
            case model.mode of
                Command _ ->
                    -- In command mode, the cursor shows on the bottom line
                    span [] [ text line ]

                Visual _ _ ->
                    getVisualTextContents model index line

                _ ->
                    let
                        lineMatches =
                            model.cursorY == actualIndex

                        actualWidth =
                            getActualScreenWidth model

                        wrappedX =
                            model.cursorX - (numberWrapped * actualWidth)

                        hasCursorX =
                            (-1 < wrappedX && wrappedX < actualWidth)

                        lastLine =
                            String.length line < actualWidth && wrappedX > -1

                        actuallyShow =
                            lineMatches && (hasCursorX || lastLine)
                    in
                        if actuallyShow then
                            renderLineWithCursor { model | cursorX = wrappedX } index line
                        else
                            span [] [ text line ]

        actualIndex =
            index + model.firstLine

        relativeNumberModePaddedIndex =
            model.cursorY
                - actualIndex
                |> abs
                |> toString
                |> String.padLeft 2 ' '
                |> String.padRight 3 ' '

        numberModePadding =
            String.length <| toString <| List.length model.lines

        numberModePaddedIndex =
            actualIndex
                |> toString
                |> String.padLeft numberModePadding ' '
                |> String.padRight (numberModePadding + 1) ' '
    in
        pre
            [ class "wrappedLine" ]
            [ textContents ]


getNormalLineInner : Model -> Int -> String -> Html msg
getNormalLineInner model index line =
    let
        textContents =
            case model.mode of
                Command _ ->
                    -- In command mode, the cursor shows on the bottom line
                    span [] [ text line ]

                Visual _ _ ->
                    getVisualTextContents model index line

                _ ->
                    let
                        actualWidth =
                            (getActualScreenWidth model)

                        cursorXInRange =
                            -1 < model.cursorX && model.cursorX < actualWidth

                        shortLine =
                            String.length line < actualWidth

                        showCursor =
                            (model.cursorY == index)
                                && (cursorXInRange || shortLine)
                    in
                        if showCursor then
                            renderLineWithCursor model index line
                        else
                            span [] [ text line ]

        relativeNumberModePaddedIndex =
            model.cursorY
                - index
                |> abs
                |> toString
                |> String.padLeft 2 ' '
                |> String.padRight 3 ' '

        numberModePadding =
            String.length <| toString <| List.length model.lines

        numberModePaddedIndex =
            index
                |> toString
                |> String.padLeft numberModePadding ' '
                |> String.padRight (numberModePadding + 1) ' '
    in
        if model.properties.relativeLineNumbers then
            pre [ class "normalLine" ]
                [ span [ class "lineNumber" ] [ text relativeNumberModePaddedIndex ]
                , textContents
                ]
        else if model.properties.lineNumbers then
            pre [ class "normalLine" ]
                [ span [ class "lineNumber" ] [ text numberModePaddedIndex ]
                , textContents
                ]
        else
            pre
                [ class "normalLine"
                ]
                [ textContents
                ]
