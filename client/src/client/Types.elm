module Types exposing (..)

import Translations 

type alias Model = 
    { lang : Translations.Lang
    , debounce : Bool
    }

type Msg 
    = Language Translations.Lang
    | Save
    