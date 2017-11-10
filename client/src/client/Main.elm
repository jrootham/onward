module Main exposing (main)

import Html exposing (Html, div, text)
import Translations as T
import ClientTypes exposing (Model, Msg)

main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }


init : ( Model, Cmd Msg )
init = (Model T.En, Cmd.none)

-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    (model, Cmd.none)

view: Model -> Html Msg
view model = 
    div [] [text (T.title model.lang)]
