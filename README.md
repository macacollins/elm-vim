![build status](https://travis-ci.org/macacollins/elm-vim.svg?branch=master)
# Statistics
## Line count statistics
### src folder
```bash
$ cloc src
      73 text files.
classified 73 files      73 unique files.                              
       0 files ignored.

github.com/AlDanial/cloc v 1.72  T=0.18 s (407.5 files/s, 20878.9 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             73            777             65           2898
-------------------------------------------------------------------------------
SUM:                            73            777             65           2898
-------------------------------------------------------------------------------
```
### tests folder
```bash
$ cloc --exclude-dir elm-stuff .
      30 text files.
classified 30 files      30 unique files.                              
       1 file ignored.

github.com/AlDanial/cloc v 1.72  T=0.09 s (332.3 files/s, 47225.0 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             29            256             41           3946
JSON                             1              0              0             20
-------------------------------------------------------------------------------
SUM:                            30            256             41           3966
-------------------------------------------------------------------------------
```
## TODOs
```bash
$ grep -r TODO src
src/Command/ExecuteCommand.elm:{- TODO see if there's a more dynamic way to do this -}
src/Control/NavigateFile.elm:            -- TODO update when we page in a more mature fashion
src/Delete/DeleteNavigationKeys.elm:-- TODO handle firstLine adjustments
src/Modes/Control.elm:                        -- TODO more thoroughly test the history here
src/Modes/Control.elm:        -- TODO move the addHistory into the functions themselves
src/Modes/Delete.elm:{- TODO consider refactoring; Delete Mode and Yank Mode are not fantastic abstractions. They should probably be toplevel rather than nested. -}
src/Modes/MacroRecord.elm:-- TODO probably refactor
src/Modes/Yank.elm:        -- TODO This is nasty. Move to Yank and YankToLine
```
