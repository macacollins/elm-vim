module Yank.CopySegment exposing (getSegmentCopyBuffer)

import Util.VisualUtils exposing (..)
import Util.ListUtils exposing (..)
import Model exposing (Model, PasteBuffer(..))


getSegmentCopyBuffer : Model -> List String
getSegmentCopyBuffer model =
    let
        ( startX, startY, endX, endY ) =
            getStartAndEnd model

        fullTargetLines =
            model.lines
                |> List.drop startY
                |> List.take (endY - startY + 1)

        croppedTargetLines =
            case fullTargetLines of
                first :: second :: rest ->
                    let
                        updatedLine =
                            String.dropLeft startX first
                    in
                        updatedLine :: second :: rest

                single :: [] ->
                    let
                        updatedLine =
                            single
                                |> String.dropLeft startX
                                |> String.dropRight ((String.length single) - endX - 1)
                    in
                        [ updatedLine ]

                [] ->
                    fullTargetLines

        final =
            case List.reverse croppedTargetLines of
                first :: second :: rest ->
                    let
                        updatedLine =
                            first
                                |> String.left (endX + 1)
                    in
                        updatedLine
                            :: second
                            :: rest
                            |> List.reverse

                _ ->
                    croppedTargetLines
    in
        final
