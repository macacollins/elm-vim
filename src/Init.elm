module Init exposing (init)

import Model exposing (Model, initialModel)
import Mode exposing (Mode(..))
import Flags exposing (Flags)


init : Flags -> ( Model, Cmd msg )
init flags =
    ( { initialModel | testsFromMacros = flags.testsFromMacros }, Cmd.none )
