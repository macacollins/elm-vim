![build status](https://travis-ci.org/macacollins/elm-vim.svg?branch=master)
# Statistics
## Line count statistics
### src folder
```bash
$ cloc src
      74 text files.
classified 74 files      74 unique files.                              
       0 files ignored.

github.com/AlDanial/cloc v 1.72  T=0.19 s (398.5 files/s, 20409.8 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             74            787             65           2938
-------------------------------------------------------------------------------
SUM:                            74            787             65           2938
-------------------------------------------------------------------------------
```
### tests folder
```bash
$ cloc --exclude-dir elm-stuff .
      30 text files.
classified 30 files      30 unique files.                              
       1 file ignored.

github.com/AlDanial/cloc v 1.72  T=0.17 s (181.8 files/s, 26210.2 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             29            264             41           4000
JSON                             1              0              0             20
-------------------------------------------------------------------------------
SUM:                            30            264             41           4020
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
