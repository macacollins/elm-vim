module Styles exposing (styleString)

import Theme exposing (getThemeColors)
import Model exposing (Model)


styleString : Model -> String
styleString model =
    let
        theme =
            getThemeColors model.properties.theme
    in
        """
main {
  background-color : """ ++ theme.mainBackgroundColor ++ """;
  color : """ ++ theme.mainColor ++ """;
  height: 100%;
}

.visual {
  background-color: aqua;
}

.wrappedLine {
  margin-left: 28.8px;
}

#cursor {
  background-color: """ ++ theme.cursorBackgroundColor ++ """;
  color: """ ++ theme.cursorColor ++ """;
  height: 20px;
  width: 1em;
}

* {
  font-family: monospace, 'Courier';
}

#modeDisplay {
  position: absolute;
  bottom: 0;
}

.normalLine {
  height: 19px;
}

pre {
  margin: 0;
}

.lineNumber {
  color: """ ++ theme.lineNumberColor ++ """;
}
"""
