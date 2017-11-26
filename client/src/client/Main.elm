module Main exposing (main)

import Html exposing (Html, a, button, div, embed, h1, hr, img, text)
import Html.Attributes exposing (class, href, id, src, alt)
import Html.Events exposing (onClick)

import Translations as T
import Ports exposing (getScreenSize, setScreenSize)
import Types exposing (..)
import Common exposing (sizeClass, contrastClass, header, footer, menuButton, rightArrow, leftArrow
    , textButton, shadowed, image)
import Menu exposing (menuPage)
import Query exposing (queryPage)
    
main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }

init : ( Model, Cmd Msg )
init = 
    let
        config = Config T.En Normal False False
        data = Data 9 "M" ""
    in
            
    (Model config True (ScreenSize 0 0) Splash Nothing data, getScreenSize "")

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

        SetGrade grade ->
            ({model | data = setGrade model.data grade}, Cmd.none)

        LocationDropdown locationList ->
            Debug.crash "TODO"

        SetLocation location ->
            ({model | data = setLocation model.data location}, Cmd.none)

        SetCareer career ->
            ({model | data = setCareer model.data career}, Cmd.none)

        SecondaryLeft ->
            Debug.crash "TODO"

        SecondaryRight ->
            Debug.crash "TODO"

----------------------------------------------------- Config setters
setSize config size =
    {config | size = size}

setContrast config contrast =
    {config | contrast = contrast}

setReader config reader =
    {config | reader = reader}

setLanguage config language =
    {config | language = language}

----------------------------------------------------- Data setters
setGrade data grade =
    {data | grade = grade}

setLocation data location =
    {data | location = location}

setCareer data career =
    {data | career = career}


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
    [header model [menuButton model]
    , div [] [image "splash" T.splash "splash" model]
    , div [class "centre"] [splashButton model (SetPage Query) T.forward]
    , footer model []
    ]

splashButton = textButton "splash-button" "splash-button" 
---------------------------------------  Explore  ----------------------------------------

explorePage: Model -> List (Html Msg)
explorePage  model =
    [header model [menuButton model]
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
    [header model [menuButton model]]

---------------------------------------  PostSecondary  ----------------------------------------

postSecondaryPage: Model -> List (Html Msg)
postSecondaryPage model =
    [header  model [menuButton model]]

---------------------------------------  Career  ----------------------------------------

careerPage: Model -> List (Html Msg)
careerPage model =
    [header model [menuButton model]]

---------------------------------------  Login  ----------------------------------------

loginPage: Model -> List (Html Msg)
loginPage model =
    [header model [menuButton model]]

---------------------------------------- Header ---------------------------------------

