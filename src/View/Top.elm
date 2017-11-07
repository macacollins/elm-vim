module View.Top exposing (topView)

import Html exposing (..)
import Model exposing (Model)
import Mode exposing (Mode(..))
import Styles exposing (styleString)
import List exposing (..)
import Json.Encode exposing (string)
import View.PortsScript exposing (..)
import View.NormalLine exposing (..)
import Html.Attributes exposing (id, class, value, href, rel, target)
import FileStorage.Model exposing (File)
import View.Line exposing (Line(..), tildeLine)
import View.Util exposing (getActualScreenWidth, getLinesInView, getLinesInView)
import Message exposing (getMessageText)


topView : Model -> Html msg
topView model =
    let
        lineRange =
            getLinesInView model

        tildeLines =
            if List.length lineRange == model.windowHeight then
                []
            else
                List.repeat (model.windowHeight - List.length lineRange) TildeLine

        lines =
            List.map (getNormalLineHTML model) (lineRange ++ tildeLines)

        styles =
            node "style" [] [ text <| styleString model ]

        mode =
            footer [ id "modeDisplay" ] <| modeFooter model

        filesList =
            case model.mode of
                FileSearch _ _ ->
                    getFilesList model

                _ ->
                    text ""

        startingMessage =
            getStartingMessage model

        children =
            startingMessage :: filesList :: styles :: mode :: portsScript :: lines
    in
        main_ [] children


getStartingMessage : Model -> Html msg
getStartingMessage model =
    if model.mode == StartingMessage then
        section
            [ id "startingMessage" ]
            [ pre [] [ text """
Cloud VIM

beta version

by Mac Collins
Source is on """, a [ href "https://github.com/macacollins/elm-vim", target "_blank", rel "noopener noreferrer" ] [ text "GitHub" ], text """
By default, this application uses localStorage for :w and :e

type  :set drive     to initialize Google Drive
type  Control + l    to initiate file search   """ ] ]
    else
        text ""


getFilesList : Model -> Html msg
getFilesList model =
    let
        ( searchString, index ) =
            case model.mode of
                FileSearch searchString innerIndex ->
                    ( searchString, innerIndex )

                _ ->
                    ( "", 0 )

        files =
            model.fileStorageModel.files
                |> List.filter (\file -> String.contains (String.toLower searchString) (String.toLower file.name))
    in
        div [ class "files" ]
            [ h2 [] [ text "File search" ]
            , input [ value searchString ] []
            , ol [] <| List.indexedMap (getFileEntry searchString index) files
            ]


getFileEntry : String -> Int -> Int -> File -> Html msg
getFileEntry searchString selectedIndex entryIndex file =
    let
        contents =
            recurIndices startingIndices file.name

        startingIndices =
            String.indices (String.toLower searchString) (String.toLower file.name)

        recurIndices indices remainingString =
            case indices of
                head :: rest ->
                    text (String.left head remainingString)
                        :: span [ class "searchText" ] [ remainingString |> String.dropLeft head |> String.left (String.length searchString) |> text ]
                        :: recurIndices rest (String.dropLeft head <| String.dropLeft (String.length searchString) <| remainingString)

                _ ->
                    [ text remainingString ]
    in
        if selectedIndex == entryIndex then
            li [ class "selected" ] contents
        else
            li [] contents


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


modeFooter : Model -> List (Html msg)
modeFooter model =
    case model.mode of
        Command command ->
            [ pre []
                [ text command
                , span [ id "cursor" ] [ text " " ]
                ]
            ]

        ShowMessage message _ ->
            [ pre [ class "error" ] [ text (getMessageText message) ] ]

        FileSearch _ _ ->
            []

        Control ->
            []

        Insert ->
            [ pre [ class "bold" ] [ text "-- INSERT --" ] ]

        EnterMacroName ->
            []

        Macro char mode ->
            let
                baseString =
                    "recording @"
                        ++ (String.cons char "")
            in
                case mode of
                    Insert ->
                        [ pre [ class "bold" ] [ text <| "-- INSERT --" ++ baseString ] ]

                    _ ->
                        [ pre [ class "bold" ] [ text baseString ] ]

        Search ->
            [ pre []
                [ text <| model.searchStringBuffer
                , span [ id "cursor" ] [ text " " ]
                ]
            ]

        _ ->
            []
