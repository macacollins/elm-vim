![build status](https://travis-ci.org/macacollins/elm-vim.svg?branch=master)
# Statistics
## Line count statistics
### src folder
```bash
$ cloc src
      80 text files.
classified 80 files      80 unique files.                              
       0 files ignored.

github.com/AlDanial/cloc v 1.72  T=0.21 s (374.6 files/s, 23817.5 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             80           1046            121           3920
-------------------------------------------------------------------------------
SUM:                            80           1046            121           3920
-------------------------------------------------------------------------------
```
### tests folder
```bash
$ cloc --exclude-dir elm-stuff .
      32 text files.
classified 32 files      32 unique files.                              
       1 file ignored.

github.com/AlDanial/cloc v 1.72  T=0.09 s (343.1 files/s, 47709.9 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             31            269             41           4120
JSON                             1              0              0             20
-------------------------------------------------------------------------------
SUM:                            32            269             41           4140
-------------------------------------------------------------------------------
```
## TODOs
```bash
$ grep -r TODO src
Binary file src/.Model.elm.swp matches
Binary file src/.Update.elm.swp matches
src/Command/ExecuteCommand.elm:                    -- TODO rewrite prolly
src/Command/ExecuteCommand.elm:                -- TODO skip?
src/Command/ExecuteCommand.elm:        -- TODO replace :set no with :set no
src/Command/ExecuteCommand.elm:        -- TODO if we get more stuff, consider :set storage=drive
src/Command/ExecuteCommand.elm:        -- TODO figure out if these should become more generic
src/Command/ExecuteCommand.elm:        -- TODO Consider :set theme=night or similar
src/Command/ExecuteCommand.elm:{- TODO see if there's a more dynamic way to do this -}
src/Delete/DeleteNavigationKeys.elm:-- TODO handle firstLine adjustments
src/FileStorage/Drive.elm:                    -- TODO rewrite prolly
src/FileStorage/Drive.elm:                -- TODO skip?
src/FileStorage/Model.elm:    -- TODO figure out better abstraction
src/FileStorage/Update.elm:-- TODO reconsider these functions. Lots of boilerplate
src/FileStorage/Update.elm:{- TODO handle position data from saved files properly
src/Model.elm:    -- TODO probably move this into the StorageMethod type
src/Modes/Control.elm:                        -- TODO more thoroughly test the history here
src/Modes/Control.elm:        -- TODO move the addHistory into the functions themselves
src/Modes/Delete.elm:        -- TODO TilBack :/
src/Modes/FileSearch.elm:-- TODO split this up?
src/Modes/FileSearch.elm:        -- TODO consider inverting this code
src/Modes/Yank.elm:        -- TODO This is nasty. Move to Yank and YankToLine
src/Properties.elm:-- TODO rename to Preferences
src/Update.elm:               TODO update this to leave this mode when vim does
src/Update.elm:            -- TODO figure out a different structure that avoids loops
```
