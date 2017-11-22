module Common exposing (sizeClass, contrastClass, translate, textButton, textButtonSelect, header, footer
                        , menuLink, rightArrow, leftArrow, innerTextButton, shadowed, image, imageLink
                        , imageSelect)

import Html exposing (Html, a, button, div, embed, h1, hr, img, text)
import Html.Attributes exposing (class, href, id, src, alt)
import Html.Events exposing (onClick)

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

translate: Model -> (T.Lang -> String) -> List (Html Msg)
translate model function =
    [text (function (getLanguage model))]

innerTextButton: Model -> Msg -> (T.Lang -> String) -> List (Html Msg)
innerTextButton model msg contents =
    [a [onClick msg] (translate model contents)]

textButton: Model -> Msg -> (T.Lang -> String) -> Html Msg
textButton model msg contents =
    div [class "text-button", contrastClass model "text-button", sizeClass model "text-button"] 
        (innerTextButton model msg contents)

textButtonSelect: Model -> Msg -> (T.Lang -> String) -> Bool -> Html Msg
textButtonSelect model msg contents selected =
    let
        colour = if selected then
            "text-button-selected"
        else
            "text-button"            
    in
            
    div [class "text-button", contrastClass model colour, sizeClass model "text-button"] 
        (innerTextButton model msg contents)

header: Model -> List (Html Msg) -> Html Msg
header model menuList  =
    div [class "header", sizeClass model "header", contrastClass model "header"] menuList

menuLink: Model -> Html Msg
menuLink model =
    imageLink model (SetPage Menu) "button" T.menu "image/menu.svg"

imageSelect : Model -> Msg -> String -> (T.Lang -> String) -> String -> Bool -> Html Msg
imageSelect model msg cssBase altText source selected =
    div [contrastClass model "selected"] [imageLink model msg cssBase altText source]

imageLink: Model -> Msg -> String -> (T.Lang -> String) -> String -> Html Msg
imageLink model msg cssBase altText source = 
    a [onClick msg] [image model cssBase altText source] 

image: Model -> String -> (T.Lang -> String) -> String -> Html Msg
image model cssBase altText source =
    img [sizeClass model cssBase, alt (altText (getLanguage model)), src source] []

---------------------------------------- Footer ---------------------------------------

footer: Model -> List (Html Msg) -> Html Msg
footer model buttonList =
    div [class "footer", class "header", sizeClass model "header", contrastClass model "header"] buttonList

---------------------------------------- Shadowed ----------------------------------------

shadowed: List (Html.Attribute Msg) -> Html Msg -> Html Msg
shadowed classes foreground  =
    div classes [div [class "shadow"] [text "&nbsp;"], div [class "container"] [foreground]]

---------------------------------------- Arrows -------------------------------------------

leftArrow: Msg -> Html Msg
leftArrow msg =
    div [] [a [onClick msg] [text "<"]]

rightArrow: Msg -> Html Msg
rightArrow msg = 
    div [] [a [onClick msg] [text ">"]]
        

