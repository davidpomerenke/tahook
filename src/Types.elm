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
    | StartQuestion String
    | QuestionAnswered Question Answer
    | RatingStarted Question (Dict Peer Answer)
    | RatingSent Rating Peer Question
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
    | QuestionStarted Int Question
    | AnswerFocused
    | AnswerTyped String
    | Rated Rating Peer Question
    | ShowChat
    | ChatTyped String
    | ChatSubmitted
    | ShowQuestions
    | QuestionTyped String
    | QuestionSubmitted
    | QuestionRemoved String
    | NextQuestionClick
    | AnswerCollectionEnded Question
    | RatingAllocated Question RatingInfo
    | Tick Int
    | NoOp


type alias RatingInfo =
    Dict Peer (Dict Peer Answer)


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
    , answers : Dict Peer AnswerItem
    }


type alias AnswerItem =
    { answer : Answer
    , ratings : Dict Peer Rating
    }


type alias Rating =
    Int


type alias Time =
    Int


type QuizState
    = NotStarted
    | Question Time Question
    | Loading Question
    | Rating Question (Dict Peer RatingItem)
    | Finished


type alias RatingItem =
    { answer : Answer
    , rating : Maybe Rating
    }


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
            [ "First question?"
            , "Second question?"
            , "Third question?"
            ]
      , chat = []
      , typedChat = ""
      , typedName = ""
      , time = Nothing
      }
    , Cmd.none
    )





type alias ChatMessage =
    { name : String, content : String }
