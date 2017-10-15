![build status](https://travis-ci.org/macacollins/elm-vim.svg?branch=master)
# Statistics
## Line count statistics
### src folder
```bash
$ cloc src
```
### tests folder
```bash
$ cloc --exclude-dir elm-stuff .
```
## TODOs
```bash
$ grep -r TODO src
src/Control/NavigateFile.elm:            -- TODO update when we page in a more mature fashion
src/Delete/DeleteNavigationKeys.elm:-- TODO handle firstLine adjustments
src/Modes/Search.elm:                        -- TODO probably restructure
src/Modes/Yank.elm:        -- TODO This is nasty. Move to Yank and YankToLine
Binary file src/Modes/.MacroRecord.elm.swp matches
src/Modes/Control.elm:-- TODO need to make this configurable
src/Modes/Control.elm:        -- TODO standardize on handle, navigate, or move
src/Modes/Control.elm:        -- TODO move the addHistory into the functions themselves
src/Modes/Control.elm:                        -- TODO more thoroughly test the history here
src/Modes/Control.elm:-- TODO move the rest of these to their own files
Binary file src/Modes/.Control.elm.swp matches
src/Modes/MacroRecord.elm:-- TODO probably refactor
src/Modes/MacroRecord.elm:            -- TODO flush buffer to dict
src/Modes/Delete.elm:{- TODO consider refactoring; Delete Mode and Yank Mode are not fantastic abstractions. They should probably be toplevel rather than nested. -}
src/Model.elm:-- TODO move this to the other syntax with named params
```
