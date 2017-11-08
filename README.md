![build status](https://travis-ci.org/macacollins/elm-vim.svg?branch=master)
# Statistics
## Line count statistics
### src folder
```bash
$ cloc src
      82 text files.
classified 82 files      82 unique files.                              
       0 files ignored.

github.com/AlDanial/cloc v 1.74  T=0.12 s (710.3 files/s, 47556.3 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             82           1130            126           4234
-------------------------------------------------------------------------------
SUM:                            82           1130            126           4234
-------------------------------------------------------------------------------
```
### tests folder
```bash
$ cloc --exclude-dir elm-stuff .
      36 text files.
classified 36 files      36 unique files.                              
       1 file ignored.

github.com/AlDanial/cloc v 1.74  T=0.06 s (616.2 files/s, 89068.3 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                             35            289             41           4854
JSON                             1              0              0             20
-------------------------------------------------------------------------------
SUM:                            36            289             41           4874
-------------------------------------------------------------------------------
```
## TODOs
```bash
$ grep -r TODO src
src/Command/ExecuteCommand.elm:                    -- TODO rewrite prolly
src/Command/ExecuteCommand.elm:                -- TODO skip?
src/Command/ExecuteCommand.elm:        -- TODO if we get more stuff, consider :set storage=drive
src/Command/ExecuteCommand.elm:        -- TODO figure out if these should become more generic
src/Command/ExecuteCommand.elm:        -- TODO Consider :set theme=night or similar
src/Command/ExecuteCommand.elm:{- TODO see if there's a more dynamic way to do this -}
src/Properties.elm:-- TODO rename to Preferences
src/Delete/DeleteNavigationKeys.elm:-- TODO handle firstLine adjustments
src/Modes/Yank.elm:-- TODO strip out this dict structure
src/Modes/Yank.elm:        -- TODO This is nasty. Move to Yank and YankToLine
Binary file src/Modes/.FileSearch.elm.swp matches
src/Modes/FileSearch.elm:-- TODO split this up?
src/Modes/FileSearch.elm:        -- TODO consider inverting this code
src/Modes/Control.elm:                        -- TODO more thoroughly test the history here
src/Modes/Control.elm:        -- TODO move the addHistory into the functions themselves
src/Modes/Insert.elm:            -- TODO make the right arrow key go past the end of the line by 1 space in insert mode
src/Modes/Delete.elm:        -- TODO TilBack :/
src/Update.elm:        -- TODO research more on the rules here
src/Update.elm:               TODO update this to leave this mode when vim does
src/Update.elm:            -- TODO figure out a different structure that avoids loops
src/Model.elm:    -- TODO probably move this into the StorageMethod type
src/FileStorage/Update.elm:-- TODO reconsider these functions. Lots of boilerplate
src/FileStorage/Update.elm:{- TODO handle position data from saved files properly
src/FileStorage/Model.elm:    -- TODO figure out better abstraction
src/FileStorage/Drive.elm:                    -- TODO rewrite prolly
src/FileStorage/Drive.elm:                -- TODO skip?
```
