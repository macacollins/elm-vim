![build status](https://travis-ci.org/macacollins/elm-vim.svg?branch=master)
# Statistics
## Line count statistics
### src folder
```bash
$ cloc src
      83 text files.
classified 83 files      83 unique files.                              
       0 files ignored.

github.com/AlDanial/cloc v 1.72  T=0.22 s (371.5 files/s, 26154.2 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             83           1201            121           4521
-------------------------------------------------------------------------------
SUM:                            83           1201            121           4521
-------------------------------------------------------------------------------
```
### tests folder
```bash
$ cloc --exclude-dir elm-stuff .
      38 text files.
classified 38 files      38 unique files.                              
       1 file ignored.

github.com/AlDanial/cloc v 1.72  T=0.12 s (319.0 files/s, 65517.1 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             37            333           1032           6419
JSON                             1              0              0             20
-------------------------------------------------------------------------------
SUM:                            38            333           1032           6439
-------------------------------------------------------------------------------
```
## TODOs
```bash
$ grep -r TODO src
Binary file src/.Update.elm.swp matches
src/Command/ExecuteCommand.elm:                    -- TODO rewrite prolly
src/Command/ExecuteCommand.elm:                -- TODO skip?
src/Command/ExecuteCommand.elm:        -- TODO if we get more stuff, consider :set storage=drive
src/Command/ExecuteCommand.elm:        -- TODO figure out if these should become more generic
src/Command/ExecuteCommand.elm:        -- TODO Consider :set theme=night or similar
src/Command/ExecuteCommand.elm:{- TODO see if there's a more dynamic way to do this -}
Binary file src/Delete/.DeleteNavigationKeys.elm.swp matches
src/Delete/DeleteNavigationKeys.elm:-- TODO handle firstLine adjustments
src/FileStorage/Drive.elm:                    -- TODO rewrite prolly
src/FileStorage/Drive.elm:                -- TODO skip?
src/FileStorage/Model.elm:    -- TODO figure out better abstraction
src/FileStorage/Update.elm:-- TODO reconsider these functions. Lots of boilerplate
src/FileStorage/Update.elm:{- TODO handle position data from saved files properly
src/Model.elm:    -- TODO probably move this into the StorageMethod type
src/Modes/Control.elm:                        -- TODO more thoroughly test the history here
src/Modes/Control.elm:        -- TODO move the addHistory into the functions themselves
src/Modes/FileSearch.elm:-- TODO split this up?
src/Modes/FileSearch.elm:        -- TODO consider inverting this code
src/Modes/Insert.elm:            -- TODO make the right arrow key go past the end of the line by 1 space in insert mode
src/Modes/NavigateToCharacter.elm:-- TODO consider more abstraction here
src/Modes/Yank.elm:-- TODO strip out this dict structure
src/Modes/Yank.elm:        -- TODO Move this to a lookup table of some sort
src/Properties.elm:-- TODO rename to Preferences
src/Update.elm:               TODO update this to leave this mode when vim does
src/Update.elm:            -- TODO figure out a different structure that avoids loops
```
