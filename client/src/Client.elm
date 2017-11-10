module Client exposing (client)

client =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }


init : ( Model, Cmd Msg )

-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

