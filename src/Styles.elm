module Styles exposing (styleString)


styleString =
    """

main {
  background-color : #DADADA;
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

"""
