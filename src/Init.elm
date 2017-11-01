module Init exposing (init)

import Model exposing (Model, initialModel)
import Command.WriteToLocalStorage exposing (loadPropertiesCommand)
import Mode exposing (Mode(..))
import Flags exposing (Flags)
import Window
import Msg exposing (Msg(..))
import Task


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        properties =
            initialModel.properties

        updatedProperties =
            { properties
                | testsFromMacros = flags.testsFromMacros
            }
    in
        ( { initialModel | properties = updatedProperties }, initialCmd )


initialCmd : Cmd Msg
initialCmd =
    Cmd.batch
        [ Task.perform WindowResized Window.size
        , loadPropertiesCommand
        ]
