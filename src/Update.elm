module Update exposing (..)

import Browser.Dom as Dom
import Dict
import Json.Decode as D
import Json.Encode as E
import List.Extra as List
import Ports exposing (..)
import Process
import Set
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

                ( Guest _, Ok (StartQuestion due q) ) ->
                    ( { model | quiz = Question due q }
                    , Process.sleep 100
                        |> Task.andThen (\_ -> Dom.focus "answer-field")
                        |> Task.attempt (\_ -> NoOp)
                    )

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
            ( model, Task.perform (\t -> NextQuestionStart (Time.posixToMillis t)) Time.now )

        NextQuestionStart time ->
            case model.role of
                Host history guests ->
                    let
                        nextQuestion =
                            model.questions
                                |> List.filterNot (\a -> Dict.member a history)
                                |> List.head

                        due =
                            time + questionDuration
                    in
                    case nextQuestion of
                        Just q ->
                            ( { model | quiz = Question due q }
                            , Cmd.batch
                                (List.map
                                    (\guest ->
                                        toPeer
                                            { peer = guest
                                            , value = encodeTypesPeerMsg (StartQuestion due q)
                                            }
                                    )
                                    guests
                                )
                            )

                        Nothing ->
                            ( { model | quiz = Finished }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        Tick time ->
            case model.quiz of
                Question due q ->
                    if time >= due then
                        ( { model
                            | quiz = Paused
                            , typedAnswer = ""
                          }
                        , case model.role of
                            Guest host ->
                                toPeer
                                    { peer = host
                                    , value = encodeTypesPeerMsg (QuestionAnswered q model.typedAnswer)
                                    }

                            _ ->
                                Cmd.none
                        )

                    else
                        ( { model | time = Just time }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        AnswerFocused ->
            ( model
            , Task.attempt (\_ -> NoOp) (Dom.focus "answer-field")
            )

        AnswerTyped a ->
            ( { model | typedAnswer = a }, Cmd.none )

        ShowQuestions ->
            ( { model | page = QuestionsPage, drawerShown = False }, Cmd.none )

        QuestionTyped a ->
            ( { model | typedQuestion = a }, Cmd.none )

        QuestionSubmitted ->
            ( { model
                | typedQuestion = ""
                , questions = model.typedQuestion :: model.questions
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
                        , answers = Dict.singleton peer a
                        }

                Just { order, answers } ->
                    Just
                        { order = order
                        , answers = Dict.insert peer a answers
                        }
        )
        h
