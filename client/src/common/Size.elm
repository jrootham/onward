port module Size exposing (getSize, setSize)

port getSize: String -> Cmd msg
port setSize : (Size -> msg) -> Sub msg

