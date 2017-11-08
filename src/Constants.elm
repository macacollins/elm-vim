module Constants exposing (..)

import Char


getTranslatedArrowKeyFromKeyUp : Int -> Int
getTranslatedArrowKeyFromKeyUp keyPress =
    if List.member keyPress [ 37, 38, 39, 40 ] then
        keyPress - 41
    else
        keyPress


upArrowKeyCode : Int
upArrowKeyCode =
    -3


upArrowKeyChar : Char
upArrowKeyChar =
    Char.fromCode upArrowKeyCode


downArrowKeyCode : Int
downArrowKeyCode =
    -1


downArrowKeyChar : Char
downArrowKeyChar =
    Char.fromCode downArrowKeyCode


leftArrowKeyCode : Int
leftArrowKeyCode =
    -4


leftArrowKeyChar : Char
leftArrowKeyChar =
    Char.fromCode leftArrowKeyCode


rightArrowKeyCode : Int
rightArrowKeyCode =
    -2


rightArrowKeyChar : Char
rightArrowKeyChar =
    Char.fromCode rightArrowKeyCode
