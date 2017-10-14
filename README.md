![build status](https://travis-ci.org/macacollins/elm-vim.svg?branch=master)
# Statistics
## Line count statistics
### src folder
```bash
$ cloc src
      50 text files.
classified 50 files      50 unique files.                              
       0 files ignored.

github.com/AlDanial/cloc v 1.72  T=0.14 s (346.8 files/s, 18516.7 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             50            540             39           2091
-------------------------------------------------------------------------------
SUM:                            50            540             39           2091
-------------------------------------------------------------------------------
```
### tests folder
```bash
$ cloc --exclude-dir elm-stuff .
      21 text files.
classified 21 files      21 unique files.                              
       1 file ignored.

github.com/AlDanial/cloc v 1.72  T=0.06 s (330.4 files/s, 44428.3 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             20            178              5           2622
JSON                             1              0              0             19
-------------------------------------------------------------------------------
SUM:                            21            178              5           2641
-------------------------------------------------------------------------------
```
## TODOs
```bash
$ grep -r TODO src
src/Control/NavigateFile.elm:            -- TODO update when we page in a more mature fashion
src/Delete/DeleteNavigationKeys.elm:-- TODO handle firstLine adjustments
src/Model.elm:-- TODO move this to the other syntax with named params
src/Modes/Control.elm:-- TODO need to make this configurable
src/Modes/MacroRecord.elm:-- TODO probably refactor
src/Modes/MacroRecord.elm:            -- TODO flush buffer to dict
src/Modes/Search.elm:                        -- TODO probably restructure
src/Util/ListUtils.elm:-- TODO change this API; we always remove stuff
```
