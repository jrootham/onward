port module Ports exposing (getScreenSize, setScreenSize)

import Types exposing (ScreenSize)

port getScreenSize: String -> Cmd msg
port setScreenSize: (ScreenSize -> msg) -> Sub msg

