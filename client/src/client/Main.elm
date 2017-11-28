module Main exposing (main)

import Html exposing (Html, a, button, div, embed, h1, hr, img, text)
import Html.Attributes exposing (class, href, id, src, alt)
import Html.Events exposing (onClick)
import Dialog

import Translations as T
import Ports exposing (getScreenSize, setScreenSize)
import Types exposing (..)
import Common exposing (sizeClass, contrastClass, header, footer, textButton, imageButton, shadowed
                        , image, simplePopup, notImplemented)
import Menu exposing (menuButton)
import Query exposing (queryPage)
    
main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }

init : ( Model, Cmd Msg )
init = 
    let
        config = Access T.En Normal False False
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

        ToggleContrast ->
            ({model | config = toggleContrast model.config}, Cmd.none)

        ToggleReader ->
            ({model | config = toggleReader model.config}, Cmd.none)

        SetLanguage language ->
            ({model | config = setLanguage model.config language}, Cmd.none)

        SetPage page ->
            ({model | page = page}, Cmd.none)

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

        Popup popup ->
            ({model | popup = Just popup}, Cmd.none)

        Close ->
            ({model | popup = Nothing}, Cmd.none)

        NotImplemented ->
            ({model | popup = Just notImplemented}, Cmd.none)

----------------------------------------------------- Access setters
setSize config size =
    {config | size = size}

toggleContrast config =
    {config | contrast = Debug.log "Contrast" (not config.contrast)}

toggleReader config  =
    {config | reader = Debug.log "Reader" (not config.reader)}

setLanguage config language =
    {config | language = language}

----------------------------------------------------- Data setters
setGrade data grade =
    {data | grade = grade}

setLocation data location =
    {data | location = location}

setCareer data career =
    {data | career = career}

----------------- view ----------------

view: Model -> Html Msg
view model = 
    if (model.screenSize.width /= 0) then
        div (outerAttributes model) [page model, Dialog.view model.popup]
    else
        div [] []

outerAttributes: Model -> List (Html.Attribute Msg)
outerAttributes model =
    [class "outer", sizeClass model "outer" , contrastClass model "contrast"]


page: Model -> Html Msg
page model =
    div [] 
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
        )

---------------------------------------  Splash --------------------------------------------

splashPage: Model -> List (Html Msg)
splashPage model = 
    [menuButton model
    , div [] [image "splash" T.splash "splash" model]
    , div [class "centre"] [splashButton model (NotImplemented) T.login]
    , div [class "centre"] [splashButton model (NotImplemented) T.tutorial]
    , div [class "centre"] [splashButton model (SetPage Query) T.forward]
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
        [ imageButton SecondaryLeft T.secondaryLeft "left-arrow" model
        , shadowed [] (secondaryBody model)
        , imageButton SecondaryRight T.secondaryRight "right-arrow" model
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

