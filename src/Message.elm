module Message exposing (Message(..), getMessageText)

import FileStorage.StorageMethod exposing (StorageMethod(..))


type Message
    = UnrecognizedCommand String


getMessageText : Message -> String
getMessageText message =
    case message of
        UnrecognizedCommand command ->
            "E492: Not an editor command: " ++ command
