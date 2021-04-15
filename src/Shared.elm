module Shared exposing (..)


questionDuration =
    10000


nGraders nAnswers =
    (nAnswers - 1)
        |> max 0
        |> min 3


sum =
    List.foldl (+) 0
