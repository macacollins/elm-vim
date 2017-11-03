module Init exposing (init)

import Model exposing (Model, initialModel)
import FileStorage.Command exposing (loadPropertiesCommand)
import Mode exposing (Mode(..))
import Flags exposing (Flags)
import Window
import Msg exposing (Msg(..))
import Task


init : ( Model, Cmd Msg )
init =
    ( initialModel, initialCmd )


initialCmd : Cmd Msg
initialCmd =
    Cmd.batch
        [ loadPropertiesCommand
        , Task.perform WindowResized Window.size
        ]
