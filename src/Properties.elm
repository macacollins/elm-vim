module Properties exposing (Properties, defaultProperties)


defaultProperties : Properties
defaultProperties =
    { testsFromMacros = False
    , lineNumbers = True
    , relativeLineNumbers = False
    }


type alias Properties =
    { testsFromMacros : Bool
    , lineNumbers : Bool
    , relativeLineNumbers : Bool
    }
