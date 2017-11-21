module Main exposing (main)

import Html exposing (Html, a, button, div, embed, h1, hr, img, text)
import Html.Attributes exposing (class, href, id, src, alt)
import Html.Events exposing (onClick)

import Translations as T
import Ports exposing (getScreenSize, setScreenSize)
import Types exposing (..)
    
main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }

init : ( Model, Cmd Msg )
init = 
    let
        config = Config T.En Normal False False
    in
            
    (Model config True (ScreenSize 0 0) Splash Nothing, getScreenSize "")

-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    setScreenSize SetScreenSize

--------------- update -------------

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        SetScreenSize screenSize ->
            ({model | screenSize = screenSize}, Cmd.none)

        SetSize size ->
            ({model | config = setSize model.config size}, Cmd.none)

        SetContrast contrast ->
            ({model | config = setContrast model.config contrast}, Cmd.none)

        SetReader reader ->
            ({model | config = setReader model.config reader}, Cmd.none)

        SetLanguage language ->
            ({model | config = setLanguage model.config language}, Cmd.none)

        SetPage page ->
            ({model | page = page}, Cmd.none)

        SecondaryLeft ->
            Debug.crash "TODO"

        SecondaryRight ->
            Debug.crash "TODO"

setSize config size =
    {config | size = size}

setContrast config contrast =
    {config | contrast = contrast}

setReader config reader =
    {config | reader = reader}

setLanguage config language =
    {config | language = language}

----------------- view ----------------

view: Model -> Html Msg
view model = 
    if (model.screenSize.width /= 0) then
        div (outerAttributes model) 
            (case model.page of
                Splash ->
                    splashPage model

                Query ->
                    queryPage model

                Explore ->
                    explorePage model

                Secondary ->
                    secondaryPage model

                PostSecondary ->
                    postSecondaryPage model

                Career ->
                    careerPage model

                Report ->
                    reportPage model

                Login ->
                     loginPage model

                Menu ->
                    menuPage model
            )
    else
        div [] []

outerAttributes: Model -> List (Html.Attribute Msg)
outerAttributes model =
    [class "outer", sizeClass model "outer" , contrastClass model "contrast"]


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

---------------------------------------  Splash --------------------------------------------

splashPage: Model -> List (Html Msg)
splashPage model = 
    [header model [menuLink model]
    , div [] [image model "splash" T.splash "image/splash.svg"]
    , div [class "centre"] 
        [div [contrastClass model "forward", sizeClass model "forward"] 
            (innerTextButton model (SetPage Explore) T.forward)
        ]
    , footer model []
    ]

translate: Model -> (T.Lang -> String) -> List (Html Msg)
translate model function =
    [text (function (getLanguage model))]

innerTextButton: Model -> Msg -> (T.Lang -> String) -> List (Html Msg)
innerTextButton model msg contents =
    [a [onClick msg] (translate model contents)]

textButton: Model -> Msg -> (T.Lang -> String) -> Html Msg
textButton model msg contents =
    div [contrastClass model "text-button", sizeClass model "text-button"] 
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
        

---------------------------------------  Query   ----------------------------------------------
queryPage: Model -> List (Html Msg)
queryPage model =
    [text "&nbsp;"]

---------------------------------------  Explore  ----------------------------------------

explorePage: Model -> List (Html Msg)
explorePage  model =
    [header model [menuLink model]
    , secondarySummary model
    , separator
    , postSummary model
    , separator
    , careerSummary model
    , footer model []
    ]

separator: Html Msg
separator = div [class "separator"] [hr [] []]

secondarySummary: Model -> Html Msg
secondarySummary model =
    div [] 
        [ leftArrow SecondaryLeft
        , shadowed [] (secondaryBody model)
        , rightArrow SecondaryRight
        ]

secondaryBody: Model -> Html Msg
secondaryBody model = 
    div [] []

postSummary: Model -> Html Msg
postSummary model =
    div [] []

careerSummary: Model -> Html Msg
careerSummary model =
    div [] []

---------------------------------------  Report ---------------------------------------

reportPage: Model -> List (Html Msg)
reportPage model= 
    [text "&nbsp"]
    
---------------------------------------  Menu  ----------------------------------------

menuPage: Model -> List (Html Msg)
menuPage model =
    [ header model []
    , pickLanguage model
    , pickSize model
    , pickContrast model
    , pickReader model
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

-------------------------------------  Secondary  ----------------------------------------

secondaryPage: Model -> List (Html Msg)
secondaryPage model =
    [header model [menuLink model]]

---------------------------------------  PostSecondary  ----------------------------------------

postSecondaryPage: Model -> List (Html Msg)
postSecondaryPage model =
    [header  model [menuLink model]]

---------------------------------------  Career  ----------------------------------------

careerPage: Model -> List (Html Msg)
careerPage model =
    [header model [menuLink model]]

---------------------------------------  Login  ----------------------------------------

loginPage: Model -> List (Html Msg)
loginPage model =
    [header model [menuLink model]]

---------------------------------------- Header ---------------------------------------

header: Model -> List (Html Msg) -> Html Msg
header model menuList  =
    div [class "header", sizeClass model "header", contrastClass model "header"] menuList

menuLink: Model -> Html Msg
menuLink model =
    a [onClick (SetPage Menu)] [image model "button" T.menu "image/menu.svg"] 


imageSelect : Model -> Msg -> String -> (T.Lang -> String) -> String -> Bool -> Html Msg
imageSelect model msg cssBase altText source selected =
    div [contrastClass model "selected"] [imageLink model msg cssBase altText source]

imageLink: Model -> Msg -> String -> (T.Lang -> String) -> String -> Html Msg
imageLink model msg cssBase altText source = 
    a [onClick msg] [image model "button" T.menu "image/menu.svg"] 

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
