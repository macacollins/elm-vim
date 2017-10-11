module Handlers.CutSegment exposing (cutSegment)

import Model exposing (Model, PasteBuffer(..))
import Handlers.CopySegment exposing (getSegmentCopyBuffer)
import Util.VisualUtils exposing (..)
import Util.ListUtils exposing (..)
import Mode exposing (Mode(Control))


cutSegment : Model -> Model
cutSegment model =
    let
        croppedTargetLines =
            getSegmentCopyBuffer model

        ( startX, startY, endX, endY ) =
            getStartAndEnd model

        startLines =
            model.lines
                |> List.take (startY + 1)
                |> List.reverse

        reversedStartLinesAfterMutation =
            mutateAtIndex 0 startLines (\line -> String.left startX line)

        endLines =
            model.lines
                |> List.drop endY

        endLinesAfterMutation =
            mutateAtIndex 0 endLines (\line -> String.dropLeft (endX + 1) line)

        combined =
            case endLinesAfterMutation of
                endHead :: endRest ->
                    case reversedStartLinesAfterMutation of
                        startHead :: startRest ->
                            (List.reverse startRest)
                                ++ [ startHead ++ endHead ]
                                ++ endRest

                        _ ->
                            endLinesAfterMutation

                _ ->
                    model.lines
    in
        { model | mode = Control, lines = combined, buffer = InlineBuffer croppedTargetLines }
