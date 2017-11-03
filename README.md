![build status](https://travis-ci.org/macacollins/elm-vim.svg?branch=master)
# Statistics
## Line count statistics
### src folder
```bash
$ cloc src
      79 text files.
classified 79 files      79 unique files.                              
       0 files ignored.

github.com/AlDanial/cloc v 1.74  T=0.11 s (694.1 files/s, 43981.3 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             79           1030            113           3863
-------------------------------------------------------------------------------
SUM:                            79           1030            113           3863
-------------------------------------------------------------------------------
```
### tests folder
```bash
$ cloc --exclude-dir elm-stuff .
      31 text files.
classified 31 files      31 unique files.                              
       1 file ignored.

github.com/AlDanial/cloc v 1.74  T=0.05 s (596.5 files/s, 85106.8 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             30            266             41           4096
JSON                             1              0              0             20
-------------------------------------------------------------------------------
SUM:                            31            266             41           4116
-------------------------------------------------------------------------------
```
## TODOs
```bash
$ grep -r TODO src
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
src/Modes/FileSearch.elm:        -- TODO consider inverting this code
src/Modes/Control.elm:                        -- TODO more thoroughly test the history here
src/Modes/Control.elm:        -- TODO move the addHistory into the functions themselves
src/Modes/Delete.elm:{- TODO consider refactoring; Delete Mode and Yank Mode are not fantastic abstractions. They should probably be toplevel rather than nested. -}
src/Modes/Delete.elm:        -- TODO TilBack :/
Binary file src/.Model.elm.swp matches
src/Update.elm:            -- TODO figure out a different structure that avoids loops
src/Model.elm:    -- TODO probably move this into the StorageMethod type
Binary file src/.Update.elm.swp matches
Binary file src/FileStorage/.Model.elm.swp matches
src/FileStorage/Update.elm:-- TODO reconsider these functions. Lots of boilerplate
src/FileStorage/Update.elm:{- TODO handle position data from saved files properly
src/FileStorage/Model.elm:    -- TODO figure out better abstraction
Binary file src/FileStorage/.Update.elm.swp matches
src/FileStorage/Drive.elm:                    -- TODO rewrite prolly
src/FileStorage/Drive.elm:                -- TODO skip?
```
