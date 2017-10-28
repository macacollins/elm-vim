module Theme exposing (Theme(..), ThemeColors, getThemeColors)


type Theme
    = Night
    | Day


type alias ThemeColors =
    { mainBackgroundColor : String
    , mainColor : String
    , cursorBackgroundColor : String
    , cursorColor : String
    , lineNumberColor : String
    }


getThemeColors : Theme -> ThemeColors
getThemeColors theme =
    case theme of
        Night ->
            { mainBackgroundColor = "#000"
            , mainColor = "rgb(187, 187, 187)"
            , cursorBackgroundColor = "rgb(187, 187, 187)"
            , cursorColor = "#FFF"
            , lineNumberColor = "rgb(255, 255, 85)"
            }

        Day ->
            { mainBackgroundColor = "#F6F6F6"
            , mainColor = "#333"
            , cursorBackgroundColor = "red"
            , cursorColor = "#333"
            , lineNumberColor = "#800"
            }
