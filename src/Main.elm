module Main exposing (..)

import Browser
import Browser.Dom as Dom
import Dict
import Html exposing (Html)
import Json.Decode as D exposing (decodeValue)
import Json.Encode as E
import List.Extra as List
import Maybe.Extra as Maybe
import Ports exposing (..)
import Process
import Random
import Random.Extra as Random
import Random.List
import Set
import Task
import Time
import Types exposing (..)
import Types.Auto exposing (..)
import Update exposing (..)
import View exposing (..)



-- MAIN


main : Program String Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- -- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        (fromPeer (\{ peer, value } -> FromPeer peer value)
            :: (case model.quiz of
                    Question _ _ ->
                        [ Time.every tickFrequency (\posix -> Tick (Time.posixToMillis posix)) ]

                    _ ->
                        []
               )
        )


tickFrequency =
    100
