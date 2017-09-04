module Init exposing (init)

import Model exposing (Model, initialModel)
import Mode exposing (Mode(..))

init = (initialModel, Cmd.none)

