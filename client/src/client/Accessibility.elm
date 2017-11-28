module Menu exposing (menuButton)

import Html exposing (Html, a, button, div, embed, h1, hr, img, text)
import Html.Attributes exposing (class, href, id, src, alt)
import Html.Events exposing (onClick)

import Translations as T
import Types exposing (..)
import Common exposing (header, footer, textButtonSelect, textButton, imageButton, simplePopup)

menuButton: Model -> Html Msg
menuButton model =
    imageButton (simplePopup (menuPopup model)) T.menu "menu" model

menuPopup: Model -> Html Msg
menuPopup model =
    div []  [ pickLanguage model
            , pickSize model
            , pickContrast model
            , pickReader model
            ]

pickLanguage: Model -> Html Msg
pickLanguage model =
    div [class "button-box"] 
        [ makeMenuButton model (SetLanguage T.En) T.english (T.En == getLanguage model)
        , makeMenuButton model (SetLanguage T.Fr) T.francais (T.Fr == getLanguage model)
        ]

pickSize: Model -> Html Msg
pickSize model =
    div [class "button-box"] 
        [ makeMenuButton model (SetSize Normal) T.normal (Normal == getSize model)
        , makeMenuButton model (SetSize Large) T.large (Large == getSize model)
        , makeMenuButton model (SetSize Larger) T.larger (Larger == getSize model)
        ]

pickContrast: Model -> Html Msg
pickContrast model =
    div [class "button-box"] [makeMenuButton model ToggleContrast T.high (getContrast model)]

pickReader: Model -> Html Msg
pickReader model =
    div [class "button-box"] [makeMenuButton model ToggleReader T.reader (getReader model)]

makeMenuButton = textButtonSelect "menu-button" "menu-button"
