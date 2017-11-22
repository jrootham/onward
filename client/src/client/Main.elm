module Main exposing (main)

import Html exposing (Html, a, button, div, embed, h1, hr, img, text)
import Html.Attributes exposing (class, href, id, src, alt)
import Html.Events exposing (onClick)

import Translations as T
import Ports exposing (getScreenSize, setScreenSize)
import Types exposing (..)
import Common exposing (sizeClass, contrastClass, header, footer, menuLink, rightArrow, leftArrow
    , innerTextButton, shadowed, image)
import Menu exposing (menuPage)
    
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
            ({model | previous = Just model.page, page = page}, Cmd.none)

        Back ->
            (back model, Cmd.none)

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

back: Model -> Model
back model =
    case model.previous of
        Just previous ->
            {model | page = previous, previous = Nothing}
        
        Nothing ->
            Debug.crash "No previousm, should not happen"            
    
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

