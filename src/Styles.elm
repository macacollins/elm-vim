module Styles exposing (styleString)


styleString =
    """
main {
  background-color : #EDAEAEA;
  color : #333;
}

.visual {
  background-color: aqua;
}

.wrappedLine {
  margin-left: 28.8px;
}

.selectedLine {
  background-color: #ADADAD;
}

#cursor {
  background-color: red;
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
  color: #800;
}

"""
