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
    background-color: #eee;
}

.searchText {
    color : darkgreen;
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

.tildeLine {
    height: 19px;
}

html, body {
    height: 100%;
    margin: 0;
}

.files h2 {
    text-align:center;
}

.files ol {
    padding-left: 0;
    margin-top: 79px;
    margin-left: 13px;
    font-size: larger;
}

#startingMessage {
    position: absolute;
    margin: auto;
    left: 0;
    right: 0;
    top: 15%;
    text-align: center;
    height: 187px;
    width: 100%;
}

.error {
    font-weight: bold;
}

li {
    list-style-type: none;
}

.files input {
    border-radius: 5px;
    border: 1px solid;
    position: absolute;
    width: 90%;
    font-size: larger;
    height: 1.9em;
    padding-left: 14px;
    left: 0;
    right: 0;
    margin: auto;
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
