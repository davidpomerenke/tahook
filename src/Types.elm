module Types exposing (..)

import Dict exposing (Dict)
import Json.Decode
import Json.Encode


type alias Peer =
    String


type alias Question =
    String


type alias Answer =
    String


type PeerMsg
    = Joined
    | JoinConfirmed
    | StartQuestion Time String
    | QuestionAnswered Question Answer
    | ChatSent String
    | ChatForwarded Peer String
    | Disconnected


type Msg
    = FromPeer Peer Json.Encode.Value
    | ToPeer Peer PeerMsg
    | SetName String
    | HostTyped String
    | QuizJoinRequested
    | QuizHosted
    | ShowDrawer
    | HideDrawer
    | ShowHome
    | AnswerFocused
    | AnswerTyped String
    | ShowChat
    | ChatTyped String
    | ChatSubmitted
    | ShowQuestions
    | QuestionTyped String
    | QuestionSubmitted
    | QuestionRemoved String
    | NextQuestionClick
    | NextQuestionStart Int
    | Tick Int
    | NoOp


type Page
    = HomePage
    | QuestionsPage
    | ChatPage


type Role
    = Guest Peer
    | Host QuizHistory (List Guest)
    | NotSelected


type alias Guest =
    Peer


type alias QuizHistory =
    Dict String QuizHistoryItem


type alias QuizHistoryItem =
    { order : Int
    , answers : Dict Peer Answer
    }


type alias Time =
    Int


type QuizState
    = NotStarted
    | Question Time String
    | Paused
    | Finished


type alias Model =
    { name : String
    , typedHost : Maybe String
    , role : Role
    , drawerShown : Bool
    , page : Page
    , quiz : QuizState
    , typedAnswer : String
    , questions : List String
    , typedQuestion : String
    , chat : List ChatMessage
    , typedChat : String
    , typedName : String
    , time : Maybe Int
    }


init : String -> ( Model, Cmd Msg )
init name =
    ( { name = name
      , typedHost = Nothing
      , role = NotSelected
      , drawerShown = False
      , page = HomePage
      , typedAnswer = ""
      , quiz = NotStarted
      , typedQuestion = ""
      , questions =
            [ "a?"
            , "b?"
            , "c?"
            ]
      , chat = []
      , typedChat = ""
      , typedName = ""
      , time = Nothing
      }
    , Cmd.none
    )


questionDuration =
    10000


type alias ChatMessage =
    { name : String, content : String }
