module Mode exposing (Mode(..))


type Mode
    = Control
    | Insert
    | Search
      -- this allows us to macro record arbitrary states (including Macro? not sure that's useful)
    | Macro Mode
    | MacroExecute
      -- Original X, original Y
    | Visual Int Int
