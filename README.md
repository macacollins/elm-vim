![build status](https://travis-ci.org/macacollins/elm-vim.svg?branch=master)
# Statistics
## Line count statistics
### src folder
```bash
$ cloc src
      78 text files.
classified 78 files      78 unique files.                              
       0 files ignored.

github.com/AlDanial/cloc v 1.74  T=0.11 s (726.9 files/s, 47033.7 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             78           1038             92           3917
-------------------------------------------------------------------------------
SUM:                            78           1038             92           3917
-------------------------------------------------------------------------------
```
### tests folder
```bash
$ cloc --exclude-dir elm-stuff .
      30 text files.
classified 30 files      30 unique files.                              
       1 file ignored.

github.com/AlDanial/cloc v 1.74  T=0.05 s (592.7 files/s, 86151.6 lines/s)
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
src/Command/WriteToLocalStorage.elm:-- TODO switch to the single port to rule them all
src/Command/ExecuteCommand.elm:        -- TODO have smarter writeLocalStorage
src/Command/ExecuteCommand.elm:                    -- TODO rewrite prolly
src/Command/ExecuteCommand.elm:                -- TODO skip?
src/Command/ExecuteCommand.elm:        -- TODO replace :set ! with :set no
src/Command/ExecuteCommand.elm:        -- TODO if we get more stuff, consider :set storage=drive
src/Command/ExecuteCommand.elm:        -- TODO figure out if these should become more generic
src/Command/ExecuteCommand.elm:        -- TODO Consider :set theme=night or similar
src/Command/ExecuteCommand.elm:{- TODO see if there's a more dynamic way to do this -}
src/Properties.elm:-- TODO rename to Preferences
src/Delete/DeleteNavigationKeys.elm:-- TODO handle firstLine adjustments
src/Modes/Yank.elm:        -- TODO This is nasty. Move to Yank and YankToLine
src/Modes/FileSearch.elm:-- TODO split this up?
src/Modes/FileSearch.elm:            -- TODO consider inverting this code
src/Modes/Control.elm:                        -- TODO more thoroughly test the history here
src/Modes/Control.elm:        -- TODO move the addHistory into the functions themselves
src/Modes/MacroRecord.elm:-- TODO probably refactor
src/Modes/Delete.elm:{- TODO consider refactoring; Delete Mode and Yank Mode are not fantastic abstractions. They should probably be toplevel rather than nested. -}
src/Model.elm:    -- TODO probably move this into the StorageMethod type
```
