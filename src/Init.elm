module Init exposing (init)

import Model exposing (Model, initialModel)
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
        ( { initialModel | properties = updatedProperties }, initialSizeCmd )


initialSizeCmd : Cmd Msg
initialSizeCmd =
    Task.perform WindowResized Window.size
