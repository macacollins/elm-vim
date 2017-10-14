![build status](https://travis-ci.org/macacollins/elm-vim.svg?branch=master)
# Statistics
## Line count statistics
### src folder
```bash
$ cloc src
      51 text files.
classified 51 files      51 unique files.                              
       0 files ignored.

github.com/AlDanial/cloc v 1.72  T=0.14 s (357.9 files/s, 18970.6 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             51            547             40           2116
-------------------------------------------------------------------------------
SUM:                            51            547             40           2116
-------------------------------------------------------------------------------
```
### tests folder
```bash
$ cloc --exclude-dir elm-stuff .
      21 text files.
classified 21 files      21 unique files.                              
       1 file ignored.

github.com/AlDanial/cloc v 1.72  T=0.07 s (302.3 files/s, 41693.5 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             20            182              5           2690
JSON                             1              0              0             19
-------------------------------------------------------------------------------
SUM:                            21            182              5           2709
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
