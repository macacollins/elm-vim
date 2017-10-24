module Init exposing (init)

import Model exposing (Model, initialModel)
import Mode exposing (Mode(..))
import Flags exposing (Flags)


init : Flags -> ( Model, Cmd msg )
init flags =
    let
        properties =
            initialModel.properties

        updatedProperties =
            { properties
                | testsFromMacros = flags.testsFromMacros
            }
    in
        ( { initialModel | properties = updatedProperties }, Cmd.none )
