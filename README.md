![build status](https://travis-ci.org/macacollins/elm-vim.svg?branch=master)
# Statistics
## Line count statistics
### src folder
```bash
$ cloc src
      64 text files.
classified 64 files      64 unique files.                              
       0 files ignored.

github.com/AlDanial/cloc v 1.72  T=0.18 s (356.1 files/s, 19318.1 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             64            735             70           2667
-------------------------------------------------------------------------------
SUM:                            64            735             70           2667
-------------------------------------------------------------------------------
```
### tests folder
```bash
$ cloc --exclude-dir elm-stuff .
      29 text files.
classified 29 files      29 unique files.                              
       1 file ignored.

github.com/AlDanial/cloc v 1.72  T=0.29 s (100.4 files/s, 14413.3 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             28            249             41           3854
JSON                             1              0              0             19
-------------------------------------------------------------------------------
SUM:                            29            249             41           3873
-------------------------------------------------------------------------------
```
## TODOs
```bash
$ grep -r TODO src
src/Control/NavigateFile.elm:            -- TODO update when we page in a more mature fashion
src/Delete/DeleteNavigationKeys.elm:-- TODO handle firstLine adjustments
src/Model.elm:-- TODO move this to the other syntax with named params
src/Modes/Control.elm:        -- TODO standardize on handle, navigate, or move
src/Modes/Control.elm:        -- TODO move the addHistory into the functions themselves
src/Modes/Control.elm:                        -- TODO more thoroughly test the history here
src/Modes/Control.elm:-- TODO move the rest of these to their own files
src/Modes/Delete.elm:{- TODO consider refactoring; Delete Mode and Yank Mode are not fantastic abstractions. They should probably be toplevel rather than nested. -}
src/Modes/MacroRecord.elm:-- TODO probably refactor
src/Modes/MacroRecord.elm:            -- TODO flush buffer to dict
src/Modes/Search.elm:                        -- TODO probably restructure
src/Modes/Yank.elm:        -- TODO This is nasty. Move to Yank and YankToLine
```
