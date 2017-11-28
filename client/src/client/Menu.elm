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
            ]

pickLanguage: Model -> Html Msg
pickLanguage model =
    div [class "button-box"] 
        [ leftMenuButton model (SetLanguage T.En) T.english (T.En == getLanguage model)
        , rightMenuButton model (SetLanguage T.Fr) T.francais (T.Fr == getLanguage model)
        ]


leftMenuButton = textButtonSelect "left-menu-button" "menu-button"
rightMenuButton = textButtonSelect "right-menu-button" "menu-button"
