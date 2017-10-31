![build status](https://travis-ci.org/macacollins/elm-vim.svg?branch=master)
# Statistics
## Line count statistics
### src folder
```bash
$ cloc src
      76 text files.
classified 76 files      76 unique files.                              
       0 files ignored.

github.com/AlDanial/cloc v 1.72  T=0.20 s (373.8 files/s, 22337.2 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             76            937             74           3530
-------------------------------------------------------------------------------
SUM:                            76            937             74           3530
-------------------------------------------------------------------------------
```
### tests folder
```bash
$ cloc --exclude-dir elm-stuff .
      30 text files.
classified 30 files      30 unique files.                              
       1 file ignored.

github.com/AlDanial/cloc v 1.72  T=0.09 s (351.1 files/s, 51041.1 lines/s)
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
Binary file src/Command/.ExecuteCommand.elm.swp matches
src/Command/ExecuteCommand.elm:                    -- TODO make this not a maybe somehow
src/Command/ExecuteCommand.elm:                    -- TODO rewrite prolly
src/Command/ExecuteCommand.elm:                -- TODO skip?
src/Command/ExecuteCommand.elm:        -- TODO figure out if I want to do it this way
src/Command/ExecuteCommand.elm:{- TODO see if there's a more dynamic way to do this -}
src/Delete/DeleteNavigationKeys.elm:-- TODO handle firstLine adjustments
src/Modes/Control.elm:                        -- TODO more thoroughly test the history here
src/Modes/Control.elm:        -- TODO move the addHistory into the functions themselves
src/Modes/Delete.elm:{- TODO consider refactoring; Delete Mode and Yank Mode are not fantastic abstractions. They should probably be toplevel rather than nested. -}
src/Modes/MacroRecord.elm:-- TODO probably refactor
src/Modes/Yank.elm:        -- TODO This is nasty. Move to Yank and YankToLine
src/Properties.elm:-- TODO rename to Preferences
```
