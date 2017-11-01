![build status](https://travis-ci.org/macacollins/elm-vim.svg?branch=master)
# Statistics
## Line count statistics
### src folder
```bash
$ cloc src
      77 text files.
classified 77 files      77 unique files.                              
       0 files ignored.

github.com/AlDanial/cloc v 1.72  T=0.20 s (378.9 files/s, 23611.4 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             77            990             89           3719
-------------------------------------------------------------------------------
SUM:                            77            990             89           3719
-------------------------------------------------------------------------------
```
### tests folder
```bash
$ cloc --exclude-dir elm-stuff .
      30 text files.
classified 30 files      30 unique files.                              
       1 file ignored.

github.com/AlDanial/cloc v 1.72  T=0.09 s (348.4 files/s, 50652.2 lines/s)
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
Binary file src/.Properties.elm.swp matches
src/Command/ExecuteCommand.elm:                    -- TODO have smarter writeLocalStorage
src/Command/ExecuteCommand.elm:                    -- TODO make this not a maybe somehow
src/Command/ExecuteCommand.elm:                    -- TODO rewrite prolly
src/Command/ExecuteCommand.elm:                -- TODO skip?
src/Command/ExecuteCommand.elm:        -- TODO replace :set ! with :set no
src/Command/ExecuteCommand.elm:        -- TODO if we get more stuff, consider :set storage=drive
src/Command/ExecuteCommand.elm:        -- TODO figure out if these should become more generic
src/Command/ExecuteCommand.elm:        -- TODO Consider :set theme=night or similar
src/Command/ExecuteCommand.elm:{- TODO see if there's a more dynamic way to do this -}
src/Delete/DeleteNavigationKeys.elm:-- TODO handle firstLine adjustments
src/Model.elm:    -- TODO probably move this into the StorageMethod type
src/Modes/Control.elm:                        -- TODO more thoroughly test the history here
src/Modes/Control.elm:        -- TODO move the addHistory into the functions themselves
src/Modes/Delete.elm:{- TODO consider refactoring; Delete Mode and Yank Mode are not fantastic abstractions. They should probably be toplevel rather than nested. -}
src/Modes/MacroRecord.elm:-- TODO probably refactor
src/Modes/Yank.elm:        -- TODO This is nasty. Move to Yank and YankToLine
src/Properties.elm:-- TODO rename to Preferences
Binary file src/View/.PortsScript.elm.swp matches
src/View/PortsScript.elm:                    // Still TODO!
```
