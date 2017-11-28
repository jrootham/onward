module Common exposing (sizeClass, contrastClass, translate, textButton, textButtonSelect, header, footer
                        , shadowed, image, imageButton, smallImageButton
                        , imageSelect, popup, simplePopup, notImplemented)

import Html exposing (Html, a, button, div, embed, h1, hr, img, text)
import Html.Attributes exposing (class, href, id, src, alt)
import Html.Events exposing (onClick)

import Dialog

import Translations as T
import Types exposing (..)

sizeClass: Model -> String -> Html.Attribute Msg
sizeClass model name =
    class (sizeName model name)

sizeName: Model -> String -> String
sizeName model name =
    case getSize model of
        Normal ->
            name ++ "-normal"

        Large ->
            name ++ "-large"

        Larger ->
            name ++ "-larger"

contrastClass: Model -> String -> Html.Attribute Msg
contrastClass model name =
    class (contrastName model name)

contrastName: Model -> String -> String
contrastName model name =
    if getContrast model then
        name ++ "-dark"
    else
        name ++ "-light"

selectedName: Bool -> String -> String
selectedName  selected name =
    if selected then
        name ++ "-selected"
    else
        name

translate: Model -> (T.Lang -> String) -> Html Msg
translate model function =
    text (function (getLanguage model))

textButton: String -> String -> Model -> Msg -> (T.Lang -> String) -> Html Msg
textButton sizeCSS colourCSS model msg contents =
    if getReader model then
        button [onClick msg] [translate model contents]
    else
        div [class sizeCSS, contrastClass model colourCSS, onClick msg] 
            [translate model contents]            

textButtonSelect: String -> String -> Model -> Msg -> (T.Lang -> String) -> Bool -> Html Msg
textButtonSelect sizeCSS colourCSS model msg contents selected =
    textButton sizeCSS (selectedName selected colourCSS) model msg contents 

header: Model -> List (Html Msg) -> Html Msg
header model menuList  =
    div [class "header", sizeClass model "header", contrastClass model "header"] menuList

imageSelect : Model -> Msg -> String -> (T.Lang -> String) -> String -> Bool -> Html Msg
imageSelect model msg cssBase altText source selected =
    imageButton msg altText (selectedName selected source) model

decoratedImageButton: String -> Msg -> (T.Lang -> String) -> String -> Model -> Html Msg
decoratedImageButton css msg altText source model =
    if getReader model then
        button [onClick msg] [translate model altText]
    else 
        a [onClick msg] [image css altText source model] 

imageButton = decoratedImageButton "image-button"
smallImageButton = decoratedImageButton "small-image-button"

image: String -> (T.Lang -> String) -> String -> Model -> Html Msg
image css altText source model =
    let
        file = "image/" ++ (contrastName model source) ++ ".svg"
    in
            
    img [class css, alt (altText (getLanguage model)), src file] []

---------------------------------------- Footer ---------------------------------------

footer: Model -> List (Html Msg) -> Html Msg
footer model buttonList =
    div [class "footer", class "header", sizeClass model "header", contrastClass model "header"] buttonList

---------------------------------------- Shadowed ----------------------------------------

shadowed: List (Html.Attribute Msg) -> Html Msg -> Html Msg
shadowed classes foreground  =
    div classes [div [class "shadow"] [], div [class "container"] [foreground]]

---------------------------------------- Arrows -------------------------------------------

makePopup: Msg -> (Html Msg) -> Dialog.Config Msg
makePopup cancel body = 
    Dialog.Config (Just cancel) Nothing Nothing (Just body) Nothing

popup: Msg -> (Html Msg) -> Msg
popup cancel body =
    Popup (makePopup cancel body)

simplePopup = popup Close

notImplemented = makePopup Close (div [class "not-implemented"] [text "Not implemented."])
