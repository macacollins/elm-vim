module Properties exposing (Properties, defaultProperties)

-- TODO rename to Preferences

import Theme exposing (Theme(..))


defaultProperties : Properties
defaultProperties =
    { testsFromMacros = False
    , lineNumbers = True
    , relativeLineNumbers = False
    , theme = Day
    }


type alias Properties =
    { testsFromMacros : Bool
    , lineNumbers : Bool
    , relativeLineNumbers : Bool
    , theme : Theme
    }
