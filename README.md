![build status](https://travis-ci.org/macacollins/elm-vim.svg?branch=master)
# Statistics
## Line count statistics
### src folder
```bash
$ cloc src
      75 text files.
classified 75 files      75 unique files.                              
       0 files ignored.

github.com/AlDanial/cloc v 1.72  T=0.19 s (393.2 files/s, 21884.8 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             75            859             71           3244
-------------------------------------------------------------------------------
SUM:                            75            859             71           3244
-------------------------------------------------------------------------------
```
### tests folder
```bash
$ cloc --exclude-dir elm-stuff .
      30 text files.
classified 30 files      30 unique files.                              
       1 file ignored.

github.com/AlDanial/cloc v 1.72  T=0.09 s (340.0 files/s, 49417.5 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             29            266             41           4034
JSON                             1              0              0             20
-------------------------------------------------------------------------------
SUM:                            30            266             41           4054
-------------------------------------------------------------------------------
```
## TODOs
```bash
$ grep -r TODO src
src/Command/ExecuteCommand.elm:        -- TODO figure out if I want to do it this way
src/Command/ExecuteCommand.elm:{- TODO see if there's a more dynamic way to do this -}
src/Delete/DeleteNavigationKeys.elm:-- TODO handle firstLine adjustments
Binary file src/Modes/.MacroRecord.elm.swp matches
src/Modes/Control.elm:                        -- TODO more thoroughly test the history here
src/Modes/Control.elm:        -- TODO move the addHistory into the functions themselves
src/Modes/Delete.elm:{- TODO consider refactoring; Delete Mode and Yank Mode are not fantastic abstractions. They should probably be toplevel rather than nested. -}
src/Modes/MacroRecord.elm:-- TODO probably refactor
src/Modes/Yank.elm:        -- TODO This is nasty. Move to Yank and YankToLine
src/Properties.elm:-- TODO rename to Preferences
```
