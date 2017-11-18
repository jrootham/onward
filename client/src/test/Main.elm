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
    , start: Position
    , position: Position
    , holderSize: Size
    }

type Msg 
    = MouseDown MousePosition
    | MouseUp MousePosition
    | MouseMove MousePosition
    | SetSize Size

init : ( Model, Cmd Msg )
init =
    let 
        start = Position 500 100
        mouse = MousePosition 0 0
        size = Size 0 0
    in 
        (Model False mouse start start size, Cmd.none)

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
            ({model | startMouse = mousePosition, start = model.position}, getSize "holder")

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
    add model.start (scale model (subtract currentMouse model.startMouse))

add: Position -> Position -> Position
add left right = 
    Position (left.x + right.x) (left.y + right.y)
            
subtract: MousePosition -> MousePosition -> MousePosition
subtract left right = 
    MousePosition (left.x - right.x) (left.y - right.y)
            
scale: Model -> MousePosition -> Position
scale model mousePosition =
    let
        xRatio = 1000.0 / toFloat(Debug.log "width" model.holderSize.width)
        yRatio = 1000.0 / toFloat(Debug.log "height" model.holderSize.height)
        x = xRatio * (toFloat mousePosition.x)
        y = yRatio * (toFloat mousePosition.y)
    in
            
    Position (Debug.log "deltaX" x) (Debug.log "deltaY" y)



-----------------------View ------------------------

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
                , r "50"
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

