![build status](https://travis-ci.org/macacollins/elm-vim.svg?branch=master)
# Statistics
## Line count statistics
### src folder
```bash
$ cloc src
      65 text files.
classified 65 files      65 unique files.                              
       0 files ignored.

github.com/AlDanial/cloc v 1.72  T=0.18 s (357.7 files/s, 19471.9 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             65            746             71           2721
-------------------------------------------------------------------------------
SUM:                            65            746             71           2721
-------------------------------------------------------------------------------
```
### tests folder
```bash
$ cloc --exclude-dir elm-stuff .
      29 text files.
classified 29 files      29 unique files.                              
       1 file ignored.

github.com/AlDanial/cloc v 1.72  T=0.08 s (349.9 files/s, 50806.0 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             28            249             41           3902
JSON                             1              0              0             19
-------------------------------------------------------------------------------
SUM:                            29            249             41           3921
-------------------------------------------------------------------------------
```
## TODOs
```bash
$ grep -r TODO src
Binary file src/.Model.elm.swp matches
src/Control/NavigateFile.elm:            -- TODO update when we page in a more mature fashion
src/Delete/DeleteNavigationKeys.elm:-- TODO handle firstLine adjustments
src/Model.elm:    -- TODO should be a Properties
src/Model.elm:-- TODO move this to the other syntax with named params
Binary file src/Modes/.MacroRecord.elm.swp matches
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
