module Menu exposing (menuPage)

import Html exposing (Html, a, button, div, embed, h1, hr, img, text)
import Html.Attributes exposing (class, href, id, src, alt)
import Html.Events exposing (onClick)

import Translations as T
import Types exposing (..)
import Common exposing (header, footer, textButtonSelect, textButton)


menuPage: Model -> List (Html Msg)
menuPage model =
    [ header model []
    , pickLanguage model
    , pickSize model
    , pickContrast model
    , pickReader model
    , div [] [textButton model Back T.back]
    , footer model []
    ]

pickLanguage: Model -> Html Msg
pickLanguage model =
    div [class "button-box"] 
        [ textButtonSelect model (SetLanguage T.En) T.english (T.En == getLanguage model)
        , textButtonSelect model (SetLanguage T.Fr) T.francais (T.Fr == getLanguage model)
        ]

pickSize: Model -> Html Msg
pickSize model =
    div [class "button-box"] 
        [ textButtonSelect model (SetSize Normal) T.normal (Normal == getSize model)
        , textButtonSelect model (SetSize Large) T.large (Large == getSize model)
        , textButtonSelect model (SetSize Larger) T.larger (Larger == getSize model)
        ]

pickContrast: Model -> Html Msg
pickContrast model =
    div [class "button-box"] 
        [ textButtonSelect model (SetContrast False) T.low (not (getContrast model))
        , textButtonSelect model (SetContrast True) T.high (getContrast model)
        ]

pickReader: Model -> Html Msg
pickReader model =
    div [class "button-box"] 
        [ textButtonSelect model (SetReader False) T.pretty (not (getReader model))
        , textButtonSelect model (SetReader True) T.reader (getReader model)
        ]
