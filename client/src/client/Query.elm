module Query exposing (queryPage)

import Html exposing (Html, div, text, input)
import Html.Attributes exposing (class)
import Dict

import Translations as T
import Types exposing (..)
import Common exposing (translate, header, footer, menuButton, imageSelect, imageButton, textButton
                        , smallImageButton)

queryPage: Model -> List (Html Msg)
queryPage model =
    [ header model [menuButton model]
    , div [] [translate model T.find]
    , div [] [translate model T.grade]
    , div [] [pickGrade model]
    , div [] [translate model T.school]
    , div [] [pickLocation model]
    , div [] [translate model T.career]
    , div [] [pickCareer model]
    , div [] [textButton "exploreButton" "exploreButton" model (SetPage Explore) T.explore]
    , footer model []
    ]

pickGrade: Model -> Html Msg
pickGrade model =
    div [class "button-box"] (List.map (\ grade -> gradeElement model grade) (List.range 9 12))

gradeElement: Model -> Int -> Html Msg
gradeElement model grade =
    let
        name = case Dict.get grade gradeName of
            Just name ->
                name

            Nothing ->
                T.invalidGrade

        source = "grade-" ++ (toString grade)
        selected = grade == getGrade model
    in
            
    imageSelect model (SetGrade grade) "grade" name source selected

gradeName = Dict.fromList [(9, T.grade9),(10, T.grade10),(11, T.grade11),(12, T.grade12)]

pickLocation: Model -> Html Msg
pickLocation model =
    let
        attempt = Dict.get (getLocation model) location2Name 
        name = case attempt of
            Just name ->
                name

            Nothing ->
                T.invalidRegion (getLanguage model)           
    in
            
    div [] [text name, smallImageButton (LocationDropdown locationList) T.locationDropdown "location" model]

locationList = [("Eastern", "K"), ("Central", "L"), ("Southwestern", "N"), ("Northern", "P"), ("Toronto", "M")]
name2Location = Dict.fromList locationList
location2Name = List.foldl 
                    (\pair dict -> Dict.insert (Tuple.second pair) (Tuple.first pair) dict) 
                    Dict.empty 
                    locationList

pickCareer: Model -> Html Msg
pickCareer model =
    input [] [text (getCareer model)]
