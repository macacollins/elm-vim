module Message exposing (Message, getMessageText)

import FileStorage.StorageMethod exposing (StorageMethod(..))


type Message
    = FileNotFound String
    | AuthenticationFailed StorageMethod


getMessageText : Message -> String
getMessageText message =
    case message of
        FileNotFound fileName ->
            "File " ++ toString fileName ++ " not found."

        AuthenticationFailed storageMethod ->
            "Unable to authenticate for "
                ++ (case storageMethod of
                        GoogleDrive ->
                            "Google Drive"

                        LocalStorage ->
                            "Local Storage."
                   )
