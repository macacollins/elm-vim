module Properties exposing (Properties, defaultProperties)


defaultProperties : Properties
defaultProperties =
    { testsFromMacros = False
    }


type alias Properties =
    { testsFromMacros : Bool
    }
