module Main exposing (main)

import Html exposing (Html, h1, div, text)
import Html.Attributes exposing (class)

import Button exposing(wideSelectButton)
import Translations as T
import Types exposing (..)

main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }


init : ( Model, Cmd Msg )
init = (Model T.En True, Cmd.none)

-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Language language ->
            ({model | lang = language}, Cmd.none)
        Save ->
            (model, Cmd.none)


view: Model -> Html Msg
view model = 
    div (outerClasses model) [h1 [] 
        [
            text (T.title model.lang)]
            , displayPanel model
        ]


outerClasses: Model -> List (Html.Attribute msg)
outerClasses model =
    [class "outer-light"]

displayPanel: Model -> Html Msg
displayPanel model =
    div [] [languagePanel model]

languagePanel: Model -> Html Msg
languagePanel model =
    div [] [wideSelectButton True (Language T.En) "English" (model.lang == T.En) model.debounce]
