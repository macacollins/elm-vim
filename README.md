![build status](https://travis-ci.org/macacollins/elm-vim.svg?branch=master)
# Statistics
## Line count statistics
### src folder
```bash
$ cloc src
      54 text files.
classified 54 files      54 unique files.                              
       0 files ignored.

github.com/AlDanial/cloc v 1.74  T=0.10 s (558.3 files/s, 31246.5 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             54            628             53           2341
-------------------------------------------------------------------------------
SUM:                            54            628             53           2341
-------------------------------------------------------------------------------
```
### tests folder
```bash
$ cloc --exclude-dir elm-stuff .
      22 text files.
classified 22 files      22 unique files.                              
       1 file ignored.

github.com/AlDanial/cloc v 1.74  T=0.04 s (505.5 files/s, 75638.5 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             21            202              5           3066
JSON                             1              0              0             19
-------------------------------------------------------------------------------
SUM:                            22            202              5           3085
-------------------------------------------------------------------------------
```
## TODOs
```bash
$ grep -r TODO src
src/Control/NavigateFile.elm:            -- TODO update when we page in a more mature fashion
src/Delete/DeleteNavigationKeys.elm:-- TODO handle firstLine adjustments
src/Modes/Search.elm:                        -- TODO probably restructure
src/Modes/Yank.elm:        -- TODO This is nasty. Move to Yank and YankToLine
src/Modes/Control.elm:-- TODO need to make this configurable
src/Modes/Control.elm:        -- TODO standardize on handle, navigate, or move
src/Modes/Control.elm:        -- TODO move the addHistory into the functions themselves
src/Modes/Control.elm:                        -- TODO more thoroughly test the history here
src/Modes/Control.elm:-- TODO move the rest of these to their own files
Binary file src/Modes/.Yank.elm.swp matches
src/Modes/MacroRecord.elm:-- TODO probably refactor
src/Modes/MacroRecord.elm:            -- TODO flush buffer to dict
Binary file src/Modes/.Delete.elm.swp matches
src/Modes/Delete.elm:{- TODO consider refactoring; Delete Mode and Yank Mode are not fantastic abstractions. They should probably be toplevel rather than nested. -}
src/Model.elm:-- TODO move this to the other syntax with named params
```
