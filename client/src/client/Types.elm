module Types exposing (..)

import Translations 
import Ports exposing (Size)

type alias Model = 
    { lang : Translations.Lang
    , debounce : Bool
    , size: Size
    }

type Msg 
    = SetSize Size
    | Language Translations.Lang
    | Save
    