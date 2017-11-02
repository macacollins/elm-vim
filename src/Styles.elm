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

.selected {
    background-color: #aaa;
}

.files {
    position: absolute;
    margin: auto;
    left: 0;
    right: 0;
    bottom: 0;
    top: 0;
    width: 500px;
    margin-top: 25px;
    background-color: white;
    color: #111;
    height: 500px;
    border-radius: 10px;
    padding-top: 8px;
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
