module View.Util exposing (getActualScreenWidth, getNumberOfLinesOnScreen, getLinesInView)

import Model exposing (Model)
import View.Line exposing (Line(..))


-- need to count tilde lines and normal lines, but not wrapped lines


getNumberOfLinesOnScreen : Model -> Int
getNumberOfLinesOnScreen model =
    let
        withWrappedLines =
            getLinesInView model

        finalLines =
            withWrappedLines ++ (List.repeat (model.windowHeight - List.length withWrappedLines) TildeLine)
    in
        finalLines
            |> List.filter isNotWrappedLine
            |> List.length


isNotWrappedLine : Line -> Bool
isNotWrappedLine line =
    case line of
        WrappedLine _ _ _ ->
            False

        _ ->
            True


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


getLinesInView : Model -> List Line
getLinesInView model =
    model.lines
        |> List.map (\line -> String.padLeft 1 ' ' line)
        |> List.indexedMap TextLine
        |> List.drop model.firstLine
        -- this take is to reduce the # of computations in the next. We may have to do this differently later
        |> List.take model.windowHeight
        |> List.foldl (foldLines model) []
        |> List.take model.windowHeight


getWrappedLines : Model -> List Line -> List Line
getWrappedLines model lines =
    List.foldl (foldLines model) [] lines


foldLines : Model -> (Line -> List Line -> List Line)
foldLines model =
    let
        actualLineWidth =
            getActualScreenWidth model

        innerFold item list =
            case item of
                TextLine index text ->
                    if String.length text > actualLineWidth then
                        list ++ (split actualLineWidth index text)
                    else
                        list ++ [ item ]

                _ ->
                    list ++ [ item ]
    in
        innerFold


split : Int -> Int -> String -> List Line
split actualWidth lineNumber text =
    TextLine lineNumber (String.left actualWidth text) :: (splitInner actualWidth lineNumber 1 (String.dropLeft actualWidth text))


splitInner : Int -> Int -> Int -> String -> List Line
splitInner actualWidth lineNumber numberSoFar remainingText =
    if String.length remainingText > actualWidth then
        WrappedLine lineNumber numberSoFar (String.left actualWidth remainingText)
            :: splitInner actualWidth lineNumber (numberSoFar + 1) (String.dropLeft actualWidth remainingText)
    else
        [ WrappedLine lineNumber numberSoFar remainingText ]
