![build status](https://travis-ci.org/macacollins/elm-vim.svg?branch=master)
# Statistics
## Line count statistics
### src folder
```bash
$ cloc src
      52 text files.
classified 52 files      52 unique files.                              
       0 files ignored.

github.com/AlDanial/cloc v 1.72  T=0.15 s (350.6 files/s, 19274.7 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             52            589             51           2219
-------------------------------------------------------------------------------
SUM:                            52            589             51           2219
-------------------------------------------------------------------------------
```
### tests folder
```bash
$ cloc --exclude-dir elm-stuff .
      21 text files.
classified 21 files      21 unique files.                              
       1 file ignored.

github.com/AlDanial/cloc v 1.72  T=0.07 s (302.0 files/s, 43730.8 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             20            193              5           2824
JSON                             1              0              0             19
-------------------------------------------------------------------------------
SUM:                            21            193              5           2843
-------------------------------------------------------------------------------
```
## TODOs
```bash
$ grep -r TODO src
src/Control/NavigateFile.elm:            -- TODO update when we page in a more mature fashion
src/Delete/DeleteNavigationKeys.elm:-- TODO handle firstLine adjustments
src/Model.elm:-- TODO move this to the other syntax with named params
Binary file src/Modes/.Delete.elm.swp matches
Binary file src/Modes/.MacroRecord.elm.swp matches
Binary file src/Modes/.Yank.elm.swp matches
src/Modes/Control.elm:-- TODO need to make this configurable
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
