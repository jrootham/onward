module ClientTypes exposing (..)

import Translations 

type alias Model = 
    { lang : Translations.Lang

    }

type Msg = 
    Save
    