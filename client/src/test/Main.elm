port module Main exposing (main)

import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class, id)
import Svg exposing (svg, circle, line)
import Svg.Attributes exposing (viewBox, cx, cy, r)
import Svg.Events exposing (on)
import Json.Decode as Decode exposing (Decoder, map)
import Json.Decode.Pipeline exposing (required, decode)


main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }

type alias Position = {x: Float, y: Float}
type alias MousePosition = {x: Int, y: Int}
type alias Size = {width: Int, height: Int}

type alias Model =
    { down: Bool
    , startMouse: MousePosition
    , position: Position
    , holderSize: Size
    }

type Msg 
    = MouseDown MousePosition
    | MouseUp MousePosition
    | MouseMove MousePosition
    | SetSize Size

init : ( Model, Cmd Msg )
init = (Model False (MousePosition 0 0) (Position 500 500) (Size 0 0), Cmd.none)

-- ports

port getSize: String -> Cmd msg
port setSize : (Size -> msg) -> Sub msg

-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    setSize SetSize

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        MouseDown mousePosition ->
            ({model | startMouse = mousePosition}, getSize "holder")

        MouseUp mousePosition ->
            ({model | position = changePosition model mousePosition, down = False}, Cmd.none)

        MouseMove mousePosition ->
            if model.down then
                ({model | position = changePosition model mousePosition}, Cmd.none)
            else
                (model, Cmd.none)

        SetSize size ->
            ({model | holderSize = size, down = True}, Cmd.none)

changePosition: Model -> MousePosition -> Position
changePosition model currentMouse =
    add model.position (scale model (subtract currentMouse model.startMouse))

add: Position -> Position -> Position
add left right = 
    Position (left.x + right.x) (left.y + right.y)
            
subtract: MousePosition -> MousePosition -> MousePosition
subtract left right = 
    Position (left.x - right.x) (left.y - right.y)
            
scale: Model -> MousePosition -> Position
scale model mousePosition =
    let
        xRatio = 1000.0 / toFloat(model.holderSize.width)
        yRatio = 1000.0 / toFloat(model.holderSize.height)
    in
            
    Position (xRatio * (toFloat mousePosition.x)) (yRatio * (toFloat mousePosition.y))

view: Model -> Html Msg
view model = 
    div [] [h1 [] [text "Testing SVG"], div [id "holder"] [svgObject model]]


svgObject: Model -> Html Msg
svgObject model =
    svg [viewBox "0 0 1000 1000"]
        [
            circle
                [ cx (toString model.position.x)
                , cy (toString model.position.y)
                , r "100"
                , on "mousedown" mouseDownDecoder
                , on "mouseup" mouseUpDecoder
                , on "mousemove" mouseMoveDecoder
                ][]
        ]


mouseDownDecoder: Decoder Msg
mouseDownDecoder = 
    positionDecoder |> map MouseDown 

mouseUpDecoder: Decoder Msg
mouseUpDecoder = 
    positionDecoder |> map MouseUp 

mouseMoveDecoder: Decoder Msg
mouseMoveDecoder = 
    positionDecoder |> map MouseMove 


positionDecoder: Decoder MousePosition
positionDecoder = 
    decode MousePosition
        |> required "x" Decode.int
        |> required "y" Decode.int

