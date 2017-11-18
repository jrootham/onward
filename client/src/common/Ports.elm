port module Ports exposing (Size, getSize, setSize)

type alias Size = {width: Int, height: Int}

port getSize: String -> Cmd msg
port setSize : (Size -> msg) -> Sub msg

