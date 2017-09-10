module Styles exposing (styleString)


styleString =
    """
main {
  background-color : #EDAEAEA;
  color : #333;
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

.lineNumber {
  padding-right: 15px;
  color: #800;
}

"""
