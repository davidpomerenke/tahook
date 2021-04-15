module Update exposing (..)

import Browser.Dom as Dom
import Dict exposing (Dict)
import Dict.Extra as Dict
import Json.Decode as D
import Json.Encode as E
import List.Extra as List
import Ports exposing (..)
import Process
import Random
import Random.Extra as Random
import Random.List
import Set
import Shared exposing (..)
import Task
import Time
import Types exposing (..)
import Types.Auto exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToPeer peer peerMsg ->
            ( model, toPeer { peer = peer, value = encodeTypesPeerMsg peerMsg } )

        FromPeer peer value ->
            case ( model.role, D.decodeValue decodeTypesPeerMsg value ) of
                ( Host h guests, Ok Joined ) ->
                    ( { model | role = Host h (peer :: guests) }
                    , toPeer { peer = peer, value = encodeTypesPeerMsg JoinConfirmed }
                    )

                ( Host h guests, Ok Disconnected ) ->
                    ( { model | role = Host h (List.remove peer guests) }, Cmd.none )

                ( Host h guests, Ok (QuestionAnswered q a) ) ->
                    ( { model | role = Host (updateHistory peer q a h) guests }, Cmd.none )

                ( _, Ok (StartQuestion q) ) ->
                    ( model
                    , Task.perform (\t -> QuestionStarted (Time.posixToMillis t + questionDuration) q) Time.now
                    )

                ( Guest _, Ok (RatingStarted q peerAnswers) ) ->
                    ( { model | quiz = Rating q (Dict.map (\_ a -> { answer = a, rating = Nothing }) peerAnswers) }
                    , Cmd.none
                    )

                ( Host h guests, Ok (RatingSent rating p question) ) ->
                    let
                        newHistory =
                            Dict.update question
                                (Maybe.map
                                    (\a ->
                                        { a
                                            | answers =
                                                Dict.update p
                                                    (Maybe.map (\b -> { b | ratings = Dict.insert peer rating b.ratings }))
                                                    a.answers
                                        }
                                    )
                                )
                                h
                    in
                    ( { model | role = Host newHistory guests }
                    , if ratingCompleted question newHistory then
                        Cmd.batch
                            (List.map
                                (\( q, ratings ) ->
                                    toPeer
                                        { peer = q
                                        , value = encodeTypesPeerMsg (FeedbackReceived question (leaderboard newHistory) ratings)
                                        }
                                )
                                (extractRatings (Dict.get question newHistory))
                            )

                      else
                        Cmd.none
                    )

                ( _, Ok (QuizFinished l m) ) ->
                    ( { model | quiz = Finished l m}, Cmd.none )

                ( Guest _, Ok (FeedbackReceived q l rating) ) ->
                    ( { model | quiz = Feedback q l rating }, Cmd.none )

                ( NotSelected, Ok JoinConfirmed ) ->
                    ( { model | role = Guest peer }, Cmd.none )

                ( Host _ guests, Ok (ChatSent a) ) ->
                    ( { model | chat = model.chat ++ [ { name = peer, content = a } ] }
                    , Cmd.batch
                        (scrollDown ()
                            :: List.map
                                (\g ->
                                    toPeer
                                        { peer = g
                                        , value = encodeTypesPeerMsg (ChatForwarded peer a)
                                        }
                                )
                                guests
                        )
                    )

                ( Guest _, Ok (ChatForwarded a b) ) ->
                    ( { model | chat = model.chat ++ [ { name = a, content = b } ] }
                    , scrollDown ()
                    )

                _ ->
                    ( model, Cmd.none )

        SetName name ->
            ( model, setName (E.string name) )

        HostTyped a ->
            ( { model | typedHost = Just a }, Cmd.none )

        QuizJoinRequested ->
            case model.typedHost of
                Just a ->
                    ( model
                    , toPeer { peer = a, value = encodeTypesPeerMsg Joined }
                    )

                _ ->
                    ( model, Cmd.none )

        QuizHosted ->
            ( { model | role = Host Dict.empty [] }, Cmd.none )

        ShowDrawer ->
            ( { model | drawerShown = True }, Cmd.none )

        HideDrawer ->
            ( { model | drawerShown = False }, Cmd.none )

        ShowHome ->
            ( { model | page = HomePage, drawerShown = False }, Cmd.none )

        NextQuestionClick ->
            case model.role of
                Host history guests ->
                    let
                        nextQuestion =
                            model.questions
                                |> List.filterNot (\a -> Dict.member a history)
                                |> List.head
                    in
                    case nextQuestion of
                        Just q ->
                            ( model
                            , Cmd.batch
                                (List.map
                                    (\guest ->
                                        toPeer
                                            { peer = guest
                                            , value = encodeTypesPeerMsg (StartQuestion q)
                                            }
                                    )
                                    (model.name :: guests)
                                )
                            )

                        Nothing ->
                            ( { model | quiz = Finished (leaderboard history) Nothing }
                            , Cmd.batch
                                (List.map
                                    (\p ->
                                        toPeer
                                            { peer = p
                                            , value = encodeTypesPeerMsg (QuizFinished (leaderboard history) Nothing)
                                            }
                                    )
                                    (model.name :: guests)
                                )
                            )

                _ ->
                    ( model, Cmd.none )

        QuestionStarted due question ->
            ( { model
                | quiz = Question due question
                , typedAnswer = ""
              }
            , Process.sleep 100
                |> Task.andThen (\_ -> Dom.focus "answer-field")
                |> Task.attempt (\_ -> NoOp)
            )

        Tick time ->
            case model.quiz of
                Question due q ->
                    if time >= due then
                        case model.role of
                            Guest host ->
                                ( { model | quiz = Loading q }
                                , if model.typedAnswer == "" then
                                    Cmd.none

                                  else
                                    toPeer
                                        { peer = host
                                        , value = encodeTypesPeerMsg (QuestionAnswered q model.typedAnswer)
                                        }
                                )

                            Host h guests ->
                                ( { model
                                    | quiz = Loading q
                                    , role =
                                        Host
                                            (case Dict.get q h of
                                                Nothing ->
                                                    Dict.insert q { order = Dict.size h, answers = Dict.empty } h

                                                Just _ ->
                                                    h
                                            )
                                            guests
                                  }
                                , Process.sleep 1000 |> Task.attempt (\_ -> AnswerCollectionEnded q)
                                )

                            _ ->
                                ( model, Cmd.none )

                    else
                        ( { model | time = Just time }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        AnswerCollectionEnded q ->
            case model.role of
                Host h _ ->
                    ( model
                    , let
                        answers : Dict Peer Answer
                        answers =
                            Dict.get q h
                                |> Maybe.map (.answers >> Dict.map (\_ v -> v.answer))
                                |> Maybe.withDefault Dict.empty
                      in
                      Random.generate (RatingAllocated q) (allocation answers)
                    )

                _ ->
                    ( model, Cmd.none )

        RatingAllocated q allocation_ ->
            ( { model | quiz = Rating q Dict.empty }
            , Cmd.batch
                (List.map
                    (\( peer, answers ) ->
                        toPeer
                            { peer = peer
                            , value = encodeTypesPeerMsg (RatingStarted q answers)
                            }
                    )
                    (Dict.toList allocation_)
                )
            )

        AnswerFocused ->
            ( model
            , Task.attempt (\_ -> NoOp) (Dom.focus "answer-field")
            )

        AnswerTyped a ->
            ( { model | typedAnswer = a }, Cmd.none )

        Rated rating peer question ->
            ( { model
                | quiz =
                    case model.quiz of
                        Rating q rs ->
                            Rating q (Dict.update peer (Maybe.map (\a -> { a | rating = Just rating })) rs)

                        _ ->
                            model.quiz
              }
            , case model.role of
                Guest host ->
                    toPeer { peer = host, value = encodeTypesPeerMsg (RatingSent rating peer question) }

                _ ->
                    Cmd.none
            )

        ShowQuestions ->
            ( { model | page = QuestionsPage, drawerShown = False }, Cmd.none )

        QuestionTyped a ->
            ( { model | typedQuestion = a }, Cmd.none )

        QuestionSubmitted ->
            ( { model
                | typedQuestion = ""
                , questions = model.questions ++ [ model.typedQuestion ]
              }
            , Cmd.none
            )

        QuestionRemoved a ->
            ( { model | questions = List.remove a model.questions }, Cmd.none )

        ShowChat ->
            ( { model | page = ChatPage, drawerShown = False }, scrollDown () )

        ChatTyped a ->
            ( { model | typedChat = a }, Cmd.none )

        ChatSubmitted ->
            ( { model | typedChat = "" }
            , toPeer
                { peer = hostId model
                , value = encodeTypesPeerMsg (ChatSent model.typedChat)
                }
            )

        NoOp ->
            ( model, Cmd.none )


hostId model =
    case model.role of
        Guest h ->
            h

        _ ->
            model.name


updateHistory peer q a h =
    Dict.update q
        (\v ->
            case v of
                Nothing ->
                    Just
                        { order = Dict.size h
                        , answers = Dict.singleton peer { answer = a, ratings = Dict.empty }
                        }

                Just { order, answers } ->
                    Just
                        { order = order
                        , answers = Dict.insert peer { answer = a, ratings = Dict.empty } answers
                        }
        )
        h


{-| Allocates to every peer and their answer three random other peers to do the peer grading.
(If there are less than three other peers, fewer peers will be allocated.)
The result is a dictionary where every peer is associated with the peers and answers that they should grade.
-}
allocation : Dict Peer Answer -> Random.Generator (Dict Peer (Dict Peer Answer))
allocation answers =
    let
        otherPeers peer =
            List.remove peer (Dict.keys answers)

        peersAndGraders : Random.Generator (List ( Peer, Peer, Answer ))
        peersAndGraders =
            Dict.toList answers
                |> Random.traverse
                    (\( gradedPeer, answer ) ->
                        otherPeers gradedPeer
                            |> randomChoices (nGraders (Dict.size answers))
                            |> Random.map (List.map (\gradingPeer -> ( gradingPeer, gradedPeer, answer )))
                    )
                |> Random.map List.concat
    in
    Random.map nestedDict peersAndGraders


{-| Choose k elements without replacement.
-}
randomChoices k =
    Random.List.choices k >> Random.map Tuple.first


nestedDict : List ( comparable1, comparable2, v ) -> Dict comparable1 (Dict comparable2 v)
nestedDict =
    Dict.groupBy first >> Dict.map (\_ -> List.map dropFirst >> Dict.fromList)


first ( a, _, _ ) =
    a


dropFirst ( _, a, b ) =
    ( a, b )


ratingCompleted : Question -> QuizHistory -> Bool
ratingCompleted q h =
    let
        answers =
            Dict.get q h
                |> Maybe.map .answers
                |> Maybe.withDefault Dict.empty

        nAnswers =
            Debug.log "nAnswers" (Dict.size answers)

        nRatings =
            Debug.log "nRatings"
                (Dict.toList answers
                    |> List.concatMap (\( _, a ) -> Dict.values a.ratings)
                    |> List.length
                )
    in
    nRatings >= (nGraders nAnswers * nAnswers)


leaderboard : QuizHistory -> Dict Peer Int
leaderboard h =
    Dict.values h
        |> List.map .answers
        |> List.concatMap
            (Dict.map (\_ a -> sum (Dict.values a.ratings))
                >> Dict.toList
            )
        |> Dict.fromListDedupe (+)


extractRatings :
    Maybe
        { answers : Dict Peer { answer : Answer, ratings : Dict Peer Rating }
        , order : Int
        }
    -> List ( Peer, Rating )
extractRatings =
    Maybe.map (.answers >> Dict.map (\_ a -> sum (Dict.values a.ratings)) >> Dict.toList)
        >> Maybe.withDefault []
