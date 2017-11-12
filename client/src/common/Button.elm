module Button exposing (..)

import Html  exposing (Html, button, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)

bevelButton : List String -> Bool -> msg -> String -> Bool -> Html msg
bevelButton otherClasses enabled click label debounce =
    let
        others = 
            if enabled && debounce then
                [class "bevel-enabled", onClick click ]        
            else
                [class "bevel-disabled"]

        classes = List.map (\name -> class name) otherClasses 
    in
            
    button (List.concat [[class "bevel-button"], classes, others]) [text label]

selectButton : List String -> Bool -> msg -> String -> Bool -> Bool-> Html msg
selectButton otherClasses enabled click label selected debounce =
    let
        others = 
            if enabled && debounce then
                if selected then
                    [class "selected-bevel-enabled", onClick click ]        
                else
                    [class "bevel-enabled", onClick click ]        
            else
                [class "bevel-disabled"]

        classes = List.map (\name -> class name) otherClasses 
    in
            
    button (List.concat [[class "bevel-button"], classes, others]) [text label]
              


thinBevelButton = bevelButton ["thin"]
normalBevelButton = bevelButton ["normal"]
wideBevelButton = bevelButton ["wide"]
widerBevelButton = bevelButton ["wider"]

thinSelectButton = selectButton ["thin"]
normalSelectButton = selectButton ["normal"]
wideSelectButton = selectButton ["wide"]
widerSelectButton = selectButton ["wider"]
