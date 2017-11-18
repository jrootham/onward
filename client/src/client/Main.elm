module Main exposing (main)

import Html exposing (Html, h1, div, text)
import Html.Attributes exposing (class, id)

import Button exposing(wideSelectButton)
import Translations as T
import Types exposing (..)
import Ports exposing (Size, getSize, setSize)


main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }


init : ( Model, Cmd Msg )
init = (Model T.En True (Size 0 0), getSize "")

-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    setSize SetSize


update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        SetSize size ->
            ({model | size = size}, Cmd.none)

        Language language ->
            ({model | lang = language}, Cmd.none)

        Save ->
            (model, Cmd.none)


view: Model -> Html Msg
view model = 
    if (model.size.width /= 0) then
        div (outerAttributes model) 
        [
            div [] 
            [ div [] [text ("Width " ++ (toString model.size.width))]
            , div [] [text ("Height " ++ (toString model.size.height))]
            ]
        ]
    else
        div [] []


outerAttributes: Model -> List (Html.Attribute msg)
outerAttributes model =
    [id "outer", class "outer-light"]

displayPanel: Model -> Html Msg
displayPanel model =
    div [] [languagePanel model]

languagePanel: Model -> Html Msg
languagePanel model =
    div [] [wideSelectButton True (Language T.En) "English" (model.lang == T.En) model.debounce]
