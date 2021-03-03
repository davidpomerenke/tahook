port module Ports exposing (..)

import Json.Encode as E
import Types exposing (..)


port toPeer : { peer : Peer, value : E.Value } -> Cmd msg


port fromPeer : ({ peer : Peer, value : E.Value } -> msg) -> Sub msg


port setName : E.Value -> Cmd msg


port scrollDown : () -> Cmd msg
