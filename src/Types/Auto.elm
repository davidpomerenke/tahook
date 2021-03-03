module Types.Auto exposing (..)


{- this file is generated by <https://github.com/choonkeat/elm-auto-encoder-decoder> do not modify manually -}


import Types exposing (..)
import Dict
import Json.Decode
import Json.Encode
import Platform
import Set



-- HARDCODE


encodeString : String -> Json.Encode.Value
encodeString =
    Json.Encode.string


encodeInt : Int -> Json.Encode.Value
encodeInt =
    Json.Encode.int


encodeFloat : Float -> Json.Encode.Value
encodeFloat =
    Json.Encode.float


encodeBool : Bool -> Json.Encode.Value
encodeBool =
    Json.Encode.bool


encodeList : (a -> Json.Encode.Value) -> List a -> Json.Encode.Value
encodeList =
    Json.Encode.list


encodeSetSet : (comparable -> Json.Encode.Value) -> Set.Set comparable -> Json.Encode.Value
encodeSetSet encoder =
    Set.toList >> encodeList encoder


encodeDictDict : (a -> Json.Encode.Value) -> (b -> Json.Encode.Value) -> Dict.Dict a b -> Json.Encode.Value
encodeDictDict keyEncoder =
    Json.Encode.dict (\k -> Json.Encode.encode 0 (keyEncoder k))


encode_Unit : () -> Json.Encode.Value
encode_Unit value =
    Json.Encode.list identity [ encodeString "" ]


encodeJsonDecodeValue : Json.Decode.Value -> Json.Encode.Value
encodeJsonDecodeValue a =
    a


encodeJsonEncodeValue : Json.Encode.Value -> Json.Encode.Value
encodeJsonEncodeValue a =
    a



--


decodeJsonDecodeValue : Json.Decode.Decoder Json.Decode.Value
decodeJsonDecodeValue =
    Json.Decode.value


decodeJsonEncodeValue : Json.Decode.Decoder Json.Decode.Value
decodeJsonEncodeValue =
    Json.Decode.value


decodeString : Json.Decode.Decoder String
decodeString =
    Json.Decode.string


decodeInt : Json.Decode.Decoder Int
decodeInt =
    Json.Decode.int


decodeFloat : Json.Decode.Decoder Float
decodeFloat =
    Json.Decode.float


decodeBool : Json.Decode.Decoder Bool
decodeBool =
    Json.Decode.bool


decodeList : (Json.Decode.Decoder a) -> Json.Decode.Decoder (List a)
decodeList =
    Json.Decode.list


decodeSetSet : (Json.Decode.Decoder comparable) -> Json.Decode.Decoder (Set.Set comparable)
decodeSetSet =
    Json.Decode.list >> Json.Decode.map Set.fromList


decodeDictDict : (Json.Decode.Decoder comparable) -> (Json.Decode.Decoder b) -> Json.Decode.Decoder (Dict.Dict comparable b)
decodeDictDict keyDecoder valueDecoder =
    Json.Decode.dict valueDecoder
        |> Json.Decode.map (\dict ->
            Dict.foldl (\string v acc ->
                case Json.Decode.decodeString keyDecoder string of
                    Ok k ->
                        Dict.insert k v acc
                    Err _ ->
                        acc
            ) Dict.empty dict
        )


decode_Unit : Json.Decode.Decoder ()
decode_Unit  =
    Json.Decode.index 0 Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "" -> (Json.Decode.succeed ())
                    _ -> Json.Decode.fail ("Unexpected Unit: " ++ word)
            )


-- PRELUDE


{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Nothing") [],CustomTypeConstructor (TitleCaseDotPhrase "Just") [ConstructorTypeParam "a"]], name = TypeName "Maybe" ["a"] } -}
encodeMaybe : (a -> Json.Encode.Value) -> Maybe a -> Json.Encode.Value
encodeMaybe arga value =
    case value of
        (Nothing) -> (Json.Encode.list identity [ encodeString "Nothing" ])
        (Just m0) -> (Json.Encode.list identity [ encodeString "Just", (arga m0) ])



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Err") [ConstructorTypeParam "x"],CustomTypeConstructor (TitleCaseDotPhrase "Ok") [ConstructorTypeParam "a"]], name = TypeName "Result" ["x","a"] } -}
encodeResult : (x -> Json.Encode.Value) -> (a -> Json.Encode.Value) -> Result x a -> Json.Encode.Value
encodeResult argx arga value =
    case value of
        (Err m0) -> (Json.Encode.list identity [ encodeString "Err", (argx m0) ])
        (Ok m0) -> (Json.Encode.list identity [ encodeString "Ok", (arga m0) ])

{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Nothing") [],CustomTypeConstructor (TitleCaseDotPhrase "Just") [ConstructorTypeParam "a"]], name = TypeName "Maybe" ["a"] } -}
decodeMaybe : (Json.Decode.Decoder (a)) -> Json.Decode.Decoder (Maybe a)
decodeMaybe arga =
    Json.Decode.index 0 Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "Nothing" -> (Json.Decode.succeed Nothing)
                    "Just" -> (Json.Decode.succeed Just |> (Json.Decode.map2 (|>) (Json.Decode.index 1 (arga))))
                    _ -> Json.Decode.fail ("Unexpected Maybe: " ++ word)
            )
                 



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Err") [ConstructorTypeParam "x"],CustomTypeConstructor (TitleCaseDotPhrase "Ok") [ConstructorTypeParam "a"]], name = TypeName "Result" ["x","a"] } -}
decodeResult : (Json.Decode.Decoder (x)) -> (Json.Decode.Decoder (a)) -> Json.Decode.Decoder (Result x a)
decodeResult argx arga =
    Json.Decode.index 0 Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "Err" -> (Json.Decode.succeed Err |> (Json.Decode.map2 (|>) (Json.Decode.index 1 (argx))))
                    "Ok" -> (Json.Decode.succeed Ok |> (Json.Decode.map2 (|>) (Json.Decode.index 1 (arga))))
                    _ -> Json.Decode.fail ("Unexpected Result: " ++ word)
            )
                 




{-| TypeAliasDef (AliasCustomType (TypeName "Types.Answer" []) (CustomTypeConstructor (TitleCaseDotPhrase "String") [])) -}
encodeTypesAnswer : Types.Answer -> Json.Encode.Value
encodeTypesAnswer value =
    (encodeString) value



{-| TypeAliasDef (AliasRecordType (TypeName "Types.ChatMessage" []) [CustomField (FieldName "name") (CustomTypeConstructor (TitleCaseDotPhrase "String") []),CustomField (FieldName "content") (CustomTypeConstructor (TitleCaseDotPhrase "String") [])]) -}
encodeTypesChatMessage : Types.ChatMessage -> Json.Encode.Value
encodeTypesChatMessage value =
    Json.Encode.object
        [ ("name", (encodeString) value.name)
        , ("content", (encodeString) value.content)
        ]



{-| TypeAliasDef (AliasCustomType (TypeName "Types.Guest" []) (CustomTypeConstructor (TitleCaseDotPhrase "Types.Peer") [])) -}
encodeTypesGuest : Types.Guest -> Json.Encode.Value
encodeTypesGuest value =
    (encodeTypesPeer) value



{-| TypeAliasDef (AliasRecordType (TypeName "Types.Model" []) [CustomField (FieldName "name") (CustomTypeConstructor (TitleCaseDotPhrase "String") []),CustomField (FieldName "typedHost") (CustomTypeConstructor (TitleCaseDotPhrase "Maybe") [CustomTypeConstructor (TitleCaseDotPhrase "String") []]),CustomField (FieldName "role") (CustomTypeConstructor (TitleCaseDotPhrase "Types.Role") []),CustomField (FieldName "drawerShown") (CustomTypeConstructor (TitleCaseDotPhrase "Bool") []),CustomField (FieldName "page") (CustomTypeConstructor (TitleCaseDotPhrase "Types.Page") []),CustomField (FieldName "quiz") (CustomTypeConstructor (TitleCaseDotPhrase "Types.QuizState") []),CustomField (FieldName "typedAnswer") (CustomTypeConstructor (TitleCaseDotPhrase "String") []),CustomField (FieldName "questions") (CustomTypeConstructor (TitleCaseDotPhrase "List") [CustomTypeConstructor (TitleCaseDotPhrase "String") []]),CustomField (FieldName "typedQuestion") (CustomTypeConstructor (TitleCaseDotPhrase "String") []),CustomField (FieldName "chat") (CustomTypeConstructor (TitleCaseDotPhrase "List") [CustomTypeConstructor (TitleCaseDotPhrase "Types.ChatMessage") []]),CustomField (FieldName "typedChat") (CustomTypeConstructor (TitleCaseDotPhrase "String") []),CustomField (FieldName "typedName") (CustomTypeConstructor (TitleCaseDotPhrase "String") []),CustomField (FieldName "time") (CustomTypeConstructor (TitleCaseDotPhrase "Maybe") [CustomTypeConstructor (TitleCaseDotPhrase "Int") []])]) -}
encodeTypesModel : Types.Model -> Json.Encode.Value
encodeTypesModel value =
    Json.Encode.object
        [ ("name", (encodeString) value.name)
        , ("typedHost", (encodeMaybe (encodeString)) value.typedHost)
        , ("role", (encodeTypesRole) value.role)
        , ("drawerShown", (encodeBool) value.drawerShown)
        , ("page", (encodeTypesPage) value.page)
        , ("quiz", (encodeTypesQuizState) value.quiz)
        , ("typedAnswer", (encodeString) value.typedAnswer)
        , ("questions", (encodeList (encodeString)) value.questions)
        , ("typedQuestion", (encodeString) value.typedQuestion)
        , ("chat", (encodeList (encodeTypesChatMessage)) value.chat)
        , ("typedChat", (encodeString) value.typedChat)
        , ("typedName", (encodeString) value.typedName)
        , ("time", (encodeMaybe (encodeInt)) value.time)
        ]



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Types.FromPeer") [CustomTypeConstructor (TitleCaseDotPhrase "Types.Peer") [],CustomTypeConstructor (TitleCaseDotPhrase "Json.Encode.Value") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.ToPeer") [CustomTypeConstructor (TitleCaseDotPhrase "Types.Peer") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.PeerMsg") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.SetName") [CustomTypeConstructor (TitleCaseDotPhrase "String") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.HostTyped") [CustomTypeConstructor (TitleCaseDotPhrase "String") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.QuizJoinRequested") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.QuizHosted") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.ShowDrawer") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.HideDrawer") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.ShowHome") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.AnswerFocused") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.AnswerTyped") [CustomTypeConstructor (TitleCaseDotPhrase "String") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.ShowChat") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.ChatTyped") [CustomTypeConstructor (TitleCaseDotPhrase "String") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.ChatSubmitted") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.ShowQuestions") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.QuestionTyped") [CustomTypeConstructor (TitleCaseDotPhrase "String") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.QuestionSubmitted") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.QuestionRemoved") [CustomTypeConstructor (TitleCaseDotPhrase "String") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.NextQuestionClick") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.NextQuestionStart") [CustomTypeConstructor (TitleCaseDotPhrase "Int") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.Tick") [CustomTypeConstructor (TitleCaseDotPhrase "Int") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.NoOp") []], name = TypeName "Types.Msg" [] } -}
encodeTypesMsg : Types.Msg -> Json.Encode.Value
encodeTypesMsg value =
    case value of
        (Types.FromPeer m0 m1) -> (Json.Encode.list identity [ encodeString "Types.FromPeer", (encodeTypesPeer m0), (encodeJsonEncodeValue m1) ])
        (Types.ToPeer m0 m1) -> (Json.Encode.list identity [ encodeString "Types.ToPeer", (encodeTypesPeer m0), (encodeTypesPeerMsg m1) ])
        (Types.SetName m0) -> (Json.Encode.list identity [ encodeString "Types.SetName", (encodeString m0) ])
        (Types.HostTyped m0) -> (Json.Encode.list identity [ encodeString "Types.HostTyped", (encodeString m0) ])
        (Types.QuizJoinRequested) -> (Json.Encode.list identity [ encodeString "Types.QuizJoinRequested" ])
        (Types.QuizHosted) -> (Json.Encode.list identity [ encodeString "Types.QuizHosted" ])
        (Types.ShowDrawer) -> (Json.Encode.list identity [ encodeString "Types.ShowDrawer" ])
        (Types.HideDrawer) -> (Json.Encode.list identity [ encodeString "Types.HideDrawer" ])
        (Types.ShowHome) -> (Json.Encode.list identity [ encodeString "Types.ShowHome" ])
        (Types.AnswerFocused) -> (Json.Encode.list identity [ encodeString "Types.AnswerFocused" ])
        (Types.AnswerTyped m0) -> (Json.Encode.list identity [ encodeString "Types.AnswerTyped", (encodeString m0) ])
        (Types.ShowChat) -> (Json.Encode.list identity [ encodeString "Types.ShowChat" ])
        (Types.ChatTyped m0) -> (Json.Encode.list identity [ encodeString "Types.ChatTyped", (encodeString m0) ])
        (Types.ChatSubmitted) -> (Json.Encode.list identity [ encodeString "Types.ChatSubmitted" ])
        (Types.ShowQuestions) -> (Json.Encode.list identity [ encodeString "Types.ShowQuestions" ])
        (Types.QuestionTyped m0) -> (Json.Encode.list identity [ encodeString "Types.QuestionTyped", (encodeString m0) ])
        (Types.QuestionSubmitted) -> (Json.Encode.list identity [ encodeString "Types.QuestionSubmitted" ])
        (Types.QuestionRemoved m0) -> (Json.Encode.list identity [ encodeString "Types.QuestionRemoved", (encodeString m0) ])
        (Types.NextQuestionClick) -> (Json.Encode.list identity [ encodeString "Types.NextQuestionClick" ])
        (Types.NextQuestionStart m0) -> (Json.Encode.list identity [ encodeString "Types.NextQuestionStart", (encodeInt m0) ])
        (Types.Tick m0) -> (Json.Encode.list identity [ encodeString "Types.Tick", (encodeInt m0) ])
        (Types.NoOp) -> (Json.Encode.list identity [ encodeString "Types.NoOp" ])



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Types.HomePage") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.QuestionsPage") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.ChatPage") []], name = TypeName "Types.Page" [] } -}
encodeTypesPage : Types.Page -> Json.Encode.Value
encodeTypesPage value =
    case value of
        (Types.HomePage) -> (Json.Encode.list identity [ encodeString "Types.HomePage" ])
        (Types.QuestionsPage) -> (Json.Encode.list identity [ encodeString "Types.QuestionsPage" ])
        (Types.ChatPage) -> (Json.Encode.list identity [ encodeString "Types.ChatPage" ])



{-| TypeAliasDef (AliasCustomType (TypeName "Types.Peer" []) (CustomTypeConstructor (TitleCaseDotPhrase "String") [])) -}
encodeTypesPeer : Types.Peer -> Json.Encode.Value
encodeTypesPeer value =
    (encodeString) value



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Types.Joined") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.JoinConfirmed") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.StartQuestion") [CustomTypeConstructor (TitleCaseDotPhrase "Types.Time") [],CustomTypeConstructor (TitleCaseDotPhrase "String") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.QuestionAnswered") [CustomTypeConstructor (TitleCaseDotPhrase "Types.Question") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.Answer") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.ChatSent") [CustomTypeConstructor (TitleCaseDotPhrase "String") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.ChatForwarded") [CustomTypeConstructor (TitleCaseDotPhrase "Types.Peer") [],CustomTypeConstructor (TitleCaseDotPhrase "String") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.Disconnected") []], name = TypeName "Types.PeerMsg" [] } -}
encodeTypesPeerMsg : Types.PeerMsg -> Json.Encode.Value
encodeTypesPeerMsg value =
    case value of
        (Types.Joined) -> (Json.Encode.list identity [ encodeString "Types.Joined" ])
        (Types.JoinConfirmed) -> (Json.Encode.list identity [ encodeString "Types.JoinConfirmed" ])
        (Types.StartQuestion m0 m1) -> (Json.Encode.list identity [ encodeString "Types.StartQuestion", (encodeTypesTime m0), (encodeString m1) ])
        (Types.QuestionAnswered m0 m1) -> (Json.Encode.list identity [ encodeString "Types.QuestionAnswered", (encodeTypesQuestion m0), (encodeTypesAnswer m1) ])
        (Types.ChatSent m0) -> (Json.Encode.list identity [ encodeString "Types.ChatSent", (encodeString m0) ])
        (Types.ChatForwarded m0 m1) -> (Json.Encode.list identity [ encodeString "Types.ChatForwarded", (encodeTypesPeer m0), (encodeString m1) ])
        (Types.Disconnected) -> (Json.Encode.list identity [ encodeString "Types.Disconnected" ])



{-| TypeAliasDef (AliasCustomType (TypeName "Types.Question" []) (CustomTypeConstructor (TitleCaseDotPhrase "String") [])) -}
encodeTypesQuestion : Types.Question -> Json.Encode.Value
encodeTypesQuestion value =
    (encodeString) value



{-| TypeAliasDef (AliasCustomType (TypeName "Types.QuizHistory" []) (CustomTypeConstructor (TitleCaseDotPhrase "Dict.Dict") [CustomTypeConstructor (TitleCaseDotPhrase "String") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.QuizHistoryItem") []])) -}
encodeTypesQuizHistory : Types.QuizHistory -> Json.Encode.Value
encodeTypesQuizHistory value =
    (encodeDictDict (encodeString) (encodeTypesQuizHistoryItem)) value



{-| TypeAliasDef (AliasRecordType (TypeName "Types.QuizHistoryItem" []) [CustomField (FieldName "order") (CustomTypeConstructor (TitleCaseDotPhrase "Int") []),CustomField (FieldName "answers") (CustomTypeConstructor (TitleCaseDotPhrase "Dict.Dict") [CustomTypeConstructor (TitleCaseDotPhrase "Types.Peer") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.Answer") []])]) -}
encodeTypesQuizHistoryItem : Types.QuizHistoryItem -> Json.Encode.Value
encodeTypesQuizHistoryItem value =
    Json.Encode.object
        [ ("order", (encodeInt) value.order)
        , ("answers", (encodeDictDict (encodeTypesPeer) (encodeTypesAnswer)) value.answers)
        ]



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Types.NotStarted") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.Question") [CustomTypeConstructor (TitleCaseDotPhrase "Types.Time") [],CustomTypeConstructor (TitleCaseDotPhrase "String") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.Paused") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.Finished") []], name = TypeName "Types.QuizState" [] } -}
encodeTypesQuizState : Types.QuizState -> Json.Encode.Value
encodeTypesQuizState value =
    case value of
        (Types.NotStarted) -> (Json.Encode.list identity [ encodeString "Types.NotStarted" ])
        (Types.Question m0 m1) -> (Json.Encode.list identity [ encodeString "Types.Question", (encodeTypesTime m0), (encodeString m1) ])
        (Types.Paused) -> (Json.Encode.list identity [ encodeString "Types.Paused" ])
        (Types.Finished) -> (Json.Encode.list identity [ encodeString "Types.Finished" ])



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Types.Guest") [CustomTypeConstructor (TitleCaseDotPhrase "Types.Peer") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.Host") [CustomTypeConstructor (TitleCaseDotPhrase "Types.QuizHistory") [],CustomTypeConstructor (TitleCaseDotPhrase "List") [CustomTypeConstructor (TitleCaseDotPhrase "Types.Guest") []]],CustomTypeConstructor (TitleCaseDotPhrase "Types.NotSelected") []], name = TypeName "Types.Role" [] } -}
encodeTypesRole : Types.Role -> Json.Encode.Value
encodeTypesRole value =
    case value of
        (Types.Guest m0) -> (Json.Encode.list identity [ encodeString "Types.Guest", (encodeTypesPeer m0) ])
        (Types.Host m0 m1) -> (Json.Encode.list identity [ encodeString "Types.Host", (encodeTypesQuizHistory m0), (encodeList (encodeTypesGuest) m1) ])
        (Types.NotSelected) -> (Json.Encode.list identity [ encodeString "Types.NotSelected" ])



{-| TypeAliasDef (AliasCustomType (TypeName "Types.Time" []) (CustomTypeConstructor (TitleCaseDotPhrase "Int") [])) -}
encodeTypesTime : Types.Time -> Json.Encode.Value
encodeTypesTime value =
    (encodeInt) value

{-| TypeAliasDef (AliasCustomType (TypeName "Types.Answer" []) (CustomTypeConstructor (TitleCaseDotPhrase "String") [])) -}
decodeTypesAnswer : Json.Decode.Decoder (Types.Answer)
decodeTypesAnswer  =
    (decodeString)



{-| TypeAliasDef (AliasRecordType (TypeName "Types.ChatMessage" []) [CustomField (FieldName "name") (CustomTypeConstructor (TitleCaseDotPhrase "String") []),CustomField (FieldName "content") (CustomTypeConstructor (TitleCaseDotPhrase "String") [])]) -}
decodeTypesChatMessage : Json.Decode.Decoder (Types.ChatMessage)
decodeTypesChatMessage  =
    Json.Decode.succeed Types.ChatMessage
        |> Json.Decode.map2 (|>) (Json.Decode.at [ "name" ] (decodeString))
        |> Json.Decode.map2 (|>) (Json.Decode.at [ "content" ] (decodeString))



{-| TypeAliasDef (AliasCustomType (TypeName "Types.Guest" []) (CustomTypeConstructor (TitleCaseDotPhrase "Types.Peer") [])) -}
decodeTypesGuest : Json.Decode.Decoder (Types.Guest)
decodeTypesGuest  =
    (decodeTypesPeer)



{-| TypeAliasDef (AliasRecordType (TypeName "Types.Model" []) [CustomField (FieldName "name") (CustomTypeConstructor (TitleCaseDotPhrase "String") []),CustomField (FieldName "typedHost") (CustomTypeConstructor (TitleCaseDotPhrase "Maybe") [CustomTypeConstructor (TitleCaseDotPhrase "String") []]),CustomField (FieldName "role") (CustomTypeConstructor (TitleCaseDotPhrase "Types.Role") []),CustomField (FieldName "drawerShown") (CustomTypeConstructor (TitleCaseDotPhrase "Bool") []),CustomField (FieldName "page") (CustomTypeConstructor (TitleCaseDotPhrase "Types.Page") []),CustomField (FieldName "quiz") (CustomTypeConstructor (TitleCaseDotPhrase "Types.QuizState") []),CustomField (FieldName "typedAnswer") (CustomTypeConstructor (TitleCaseDotPhrase "String") []),CustomField (FieldName "questions") (CustomTypeConstructor (TitleCaseDotPhrase "List") [CustomTypeConstructor (TitleCaseDotPhrase "String") []]),CustomField (FieldName "typedQuestion") (CustomTypeConstructor (TitleCaseDotPhrase "String") []),CustomField (FieldName "chat") (CustomTypeConstructor (TitleCaseDotPhrase "List") [CustomTypeConstructor (TitleCaseDotPhrase "Types.ChatMessage") []]),CustomField (FieldName "typedChat") (CustomTypeConstructor (TitleCaseDotPhrase "String") []),CustomField (FieldName "typedName") (CustomTypeConstructor (TitleCaseDotPhrase "String") []),CustomField (FieldName "time") (CustomTypeConstructor (TitleCaseDotPhrase "Maybe") [CustomTypeConstructor (TitleCaseDotPhrase "Int") []])]) -}
decodeTypesModel : Json.Decode.Decoder (Types.Model)
decodeTypesModel  =
    Json.Decode.succeed Types.Model
        |> Json.Decode.map2 (|>) (Json.Decode.at [ "name" ] (decodeString))
        |> Json.Decode.map2 (|>) (Json.Decode.oneOf [Json.Decode.at [ "typedHost" ] (decodeMaybe (decodeString)), Json.Decode.succeed Nothing])
        |> Json.Decode.map2 (|>) (Json.Decode.at [ "role" ] (decodeTypesRole))
        |> Json.Decode.map2 (|>) (Json.Decode.at [ "drawerShown" ] (decodeBool))
        |> Json.Decode.map2 (|>) (Json.Decode.at [ "page" ] (decodeTypesPage))
        |> Json.Decode.map2 (|>) (Json.Decode.at [ "quiz" ] (decodeTypesQuizState))
        |> Json.Decode.map2 (|>) (Json.Decode.at [ "typedAnswer" ] (decodeString))
        |> Json.Decode.map2 (|>) (Json.Decode.at [ "questions" ] (decodeList (decodeString)))
        |> Json.Decode.map2 (|>) (Json.Decode.at [ "typedQuestion" ] (decodeString))
        |> Json.Decode.map2 (|>) (Json.Decode.at [ "chat" ] (decodeList (decodeTypesChatMessage)))
        |> Json.Decode.map2 (|>) (Json.Decode.at [ "typedChat" ] (decodeString))
        |> Json.Decode.map2 (|>) (Json.Decode.at [ "typedName" ] (decodeString))
        |> Json.Decode.map2 (|>) (Json.Decode.oneOf [Json.Decode.at [ "time" ] (decodeMaybe (decodeInt)), Json.Decode.succeed Nothing])



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Types.FromPeer") [CustomTypeConstructor (TitleCaseDotPhrase "Types.Peer") [],CustomTypeConstructor (TitleCaseDotPhrase "Json.Encode.Value") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.ToPeer") [CustomTypeConstructor (TitleCaseDotPhrase "Types.Peer") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.PeerMsg") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.SetName") [CustomTypeConstructor (TitleCaseDotPhrase "String") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.HostTyped") [CustomTypeConstructor (TitleCaseDotPhrase "String") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.QuizJoinRequested") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.QuizHosted") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.ShowDrawer") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.HideDrawer") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.ShowHome") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.AnswerFocused") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.AnswerTyped") [CustomTypeConstructor (TitleCaseDotPhrase "String") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.ShowChat") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.ChatTyped") [CustomTypeConstructor (TitleCaseDotPhrase "String") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.ChatSubmitted") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.ShowQuestions") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.QuestionTyped") [CustomTypeConstructor (TitleCaseDotPhrase "String") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.QuestionSubmitted") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.QuestionRemoved") [CustomTypeConstructor (TitleCaseDotPhrase "String") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.NextQuestionClick") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.NextQuestionStart") [CustomTypeConstructor (TitleCaseDotPhrase "Int") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.Tick") [CustomTypeConstructor (TitleCaseDotPhrase "Int") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.NoOp") []], name = TypeName "Types.Msg" [] } -}
decodeTypesMsg : Json.Decode.Decoder (Types.Msg)
decodeTypesMsg  =
    Json.Decode.index 0 Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "Types.FromPeer" -> (Json.Decode.succeed Types.FromPeer |> (Json.Decode.map2 (|>) (Json.Decode.index 1 (decodeTypesPeer))) |> (Json.Decode.map2 (|>) (Json.Decode.index 2 (decodeJsonEncodeValue))))
                    "Types.ToPeer" -> (Json.Decode.succeed Types.ToPeer |> (Json.Decode.map2 (|>) (Json.Decode.index 1 (decodeTypesPeer))) |> (Json.Decode.map2 (|>) (Json.Decode.index 2 (decodeTypesPeerMsg))))
                    "Types.SetName" -> (Json.Decode.succeed Types.SetName |> (Json.Decode.map2 (|>) (Json.Decode.index 1 (decodeString))))
                    "Types.HostTyped" -> (Json.Decode.succeed Types.HostTyped |> (Json.Decode.map2 (|>) (Json.Decode.index 1 (decodeString))))
                    "Types.QuizJoinRequested" -> (Json.Decode.succeed Types.QuizJoinRequested)
                    "Types.QuizHosted" -> (Json.Decode.succeed Types.QuizHosted)
                    "Types.ShowDrawer" -> (Json.Decode.succeed Types.ShowDrawer)
                    "Types.HideDrawer" -> (Json.Decode.succeed Types.HideDrawer)
                    "Types.ShowHome" -> (Json.Decode.succeed Types.ShowHome)
                    "Types.AnswerFocused" -> (Json.Decode.succeed Types.AnswerFocused)
                    "Types.AnswerTyped" -> (Json.Decode.succeed Types.AnswerTyped |> (Json.Decode.map2 (|>) (Json.Decode.index 1 (decodeString))))
                    "Types.ShowChat" -> (Json.Decode.succeed Types.ShowChat)
                    "Types.ChatTyped" -> (Json.Decode.succeed Types.ChatTyped |> (Json.Decode.map2 (|>) (Json.Decode.index 1 (decodeString))))
                    "Types.ChatSubmitted" -> (Json.Decode.succeed Types.ChatSubmitted)
                    "Types.ShowQuestions" -> (Json.Decode.succeed Types.ShowQuestions)
                    "Types.QuestionTyped" -> (Json.Decode.succeed Types.QuestionTyped |> (Json.Decode.map2 (|>) (Json.Decode.index 1 (decodeString))))
                    "Types.QuestionSubmitted" -> (Json.Decode.succeed Types.QuestionSubmitted)
                    "Types.QuestionRemoved" -> (Json.Decode.succeed Types.QuestionRemoved |> (Json.Decode.map2 (|>) (Json.Decode.index 1 (decodeString))))
                    "Types.NextQuestionClick" -> (Json.Decode.succeed Types.NextQuestionClick)
                    "Types.NextQuestionStart" -> (Json.Decode.succeed Types.NextQuestionStart |> (Json.Decode.map2 (|>) (Json.Decode.index 1 (decodeInt))))
                    "Types.Tick" -> (Json.Decode.succeed Types.Tick |> (Json.Decode.map2 (|>) (Json.Decode.index 1 (decodeInt))))
                    "Types.NoOp" -> (Json.Decode.succeed Types.NoOp)
                    _ -> Json.Decode.fail ("Unexpected Types.Msg: " ++ word)
            )
                 



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Types.HomePage") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.QuestionsPage") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.ChatPage") []], name = TypeName "Types.Page" [] } -}
decodeTypesPage : Json.Decode.Decoder (Types.Page)
decodeTypesPage  =
    Json.Decode.index 0 Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "Types.HomePage" -> (Json.Decode.succeed Types.HomePage)
                    "Types.QuestionsPage" -> (Json.Decode.succeed Types.QuestionsPage)
                    "Types.ChatPage" -> (Json.Decode.succeed Types.ChatPage)
                    _ -> Json.Decode.fail ("Unexpected Types.Page: " ++ word)
            )
                 



{-| TypeAliasDef (AliasCustomType (TypeName "Types.Peer" []) (CustomTypeConstructor (TitleCaseDotPhrase "String") [])) -}
decodeTypesPeer : Json.Decode.Decoder (Types.Peer)
decodeTypesPeer  =
    (decodeString)



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Types.Joined") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.JoinConfirmed") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.StartQuestion") [CustomTypeConstructor (TitleCaseDotPhrase "Types.Time") [],CustomTypeConstructor (TitleCaseDotPhrase "String") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.QuestionAnswered") [CustomTypeConstructor (TitleCaseDotPhrase "Types.Question") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.Answer") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.ChatSent") [CustomTypeConstructor (TitleCaseDotPhrase "String") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.ChatForwarded") [CustomTypeConstructor (TitleCaseDotPhrase "Types.Peer") [],CustomTypeConstructor (TitleCaseDotPhrase "String") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.Disconnected") []], name = TypeName "Types.PeerMsg" [] } -}
decodeTypesPeerMsg : Json.Decode.Decoder (Types.PeerMsg)
decodeTypesPeerMsg  =
    Json.Decode.index 0 Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "Types.Joined" -> (Json.Decode.succeed Types.Joined)
                    "Types.JoinConfirmed" -> (Json.Decode.succeed Types.JoinConfirmed)
                    "Types.StartQuestion" -> (Json.Decode.succeed Types.StartQuestion |> (Json.Decode.map2 (|>) (Json.Decode.index 1 (decodeTypesTime))) |> (Json.Decode.map2 (|>) (Json.Decode.index 2 (decodeString))))
                    "Types.QuestionAnswered" -> (Json.Decode.succeed Types.QuestionAnswered |> (Json.Decode.map2 (|>) (Json.Decode.index 1 (decodeTypesQuestion))) |> (Json.Decode.map2 (|>) (Json.Decode.index 2 (decodeTypesAnswer))))
                    "Types.ChatSent" -> (Json.Decode.succeed Types.ChatSent |> (Json.Decode.map2 (|>) (Json.Decode.index 1 (decodeString))))
                    "Types.ChatForwarded" -> (Json.Decode.succeed Types.ChatForwarded |> (Json.Decode.map2 (|>) (Json.Decode.index 1 (decodeTypesPeer))) |> (Json.Decode.map2 (|>) (Json.Decode.index 2 (decodeString))))
                    "Types.Disconnected" -> (Json.Decode.succeed Types.Disconnected)
                    _ -> Json.Decode.fail ("Unexpected Types.PeerMsg: " ++ word)
            )
                 



{-| TypeAliasDef (AliasCustomType (TypeName "Types.Question" []) (CustomTypeConstructor (TitleCaseDotPhrase "String") [])) -}
decodeTypesQuestion : Json.Decode.Decoder (Types.Question)
decodeTypesQuestion  =
    (decodeString)



{-| TypeAliasDef (AliasCustomType (TypeName "Types.QuizHistory" []) (CustomTypeConstructor (TitleCaseDotPhrase "Dict.Dict") [CustomTypeConstructor (TitleCaseDotPhrase "String") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.QuizHistoryItem") []])) -}
decodeTypesQuizHistory : Json.Decode.Decoder (Types.QuizHistory)
decodeTypesQuizHistory  =
    (decodeDictDict (decodeString) (decodeTypesQuizHistoryItem))



{-| TypeAliasDef (AliasRecordType (TypeName "Types.QuizHistoryItem" []) [CustomField (FieldName "order") (CustomTypeConstructor (TitleCaseDotPhrase "Int") []),CustomField (FieldName "answers") (CustomTypeConstructor (TitleCaseDotPhrase "Dict.Dict") [CustomTypeConstructor (TitleCaseDotPhrase "Types.Peer") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.Answer") []])]) -}
decodeTypesQuizHistoryItem : Json.Decode.Decoder (Types.QuizHistoryItem)
decodeTypesQuizHistoryItem  =
    Json.Decode.succeed Types.QuizHistoryItem
        |> Json.Decode.map2 (|>) (Json.Decode.at [ "order" ] (decodeInt))
        |> Json.Decode.map2 (|>) (Json.Decode.at [ "answers" ] (decodeDictDict (decodeTypesPeer) (decodeTypesAnswer)))



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Types.NotStarted") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.Question") [CustomTypeConstructor (TitleCaseDotPhrase "Types.Time") [],CustomTypeConstructor (TitleCaseDotPhrase "String") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.Paused") [],CustomTypeConstructor (TitleCaseDotPhrase "Types.Finished") []], name = TypeName "Types.QuizState" [] } -}
decodeTypesQuizState : Json.Decode.Decoder (Types.QuizState)
decodeTypesQuizState  =
    Json.Decode.index 0 Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "Types.NotStarted" -> (Json.Decode.succeed Types.NotStarted)
                    "Types.Question" -> (Json.Decode.succeed Types.Question |> (Json.Decode.map2 (|>) (Json.Decode.index 1 (decodeTypesTime))) |> (Json.Decode.map2 (|>) (Json.Decode.index 2 (decodeString))))
                    "Types.Paused" -> (Json.Decode.succeed Types.Paused)
                    "Types.Finished" -> (Json.Decode.succeed Types.Finished)
                    _ -> Json.Decode.fail ("Unexpected Types.QuizState: " ++ word)
            )
                 



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Types.Guest") [CustomTypeConstructor (TitleCaseDotPhrase "Types.Peer") []],CustomTypeConstructor (TitleCaseDotPhrase "Types.Host") [CustomTypeConstructor (TitleCaseDotPhrase "Types.QuizHistory") [],CustomTypeConstructor (TitleCaseDotPhrase "List") [CustomTypeConstructor (TitleCaseDotPhrase "Types.Guest") []]],CustomTypeConstructor (TitleCaseDotPhrase "Types.NotSelected") []], name = TypeName "Types.Role" [] } -}
decodeTypesRole : Json.Decode.Decoder (Types.Role)
decodeTypesRole  =
    Json.Decode.index 0 Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "Types.Guest" -> (Json.Decode.succeed Types.Guest |> (Json.Decode.map2 (|>) (Json.Decode.index 1 (decodeTypesPeer))))
                    "Types.Host" -> (Json.Decode.succeed Types.Host |> (Json.Decode.map2 (|>) (Json.Decode.index 1 (decodeTypesQuizHistory))) |> (Json.Decode.map2 (|>) (Json.Decode.index 2 (decodeList (decodeTypesGuest)))))
                    "Types.NotSelected" -> (Json.Decode.succeed Types.NotSelected)
                    _ -> Json.Decode.fail ("Unexpected Types.Role: " ++ word)
            )
                 



{-| TypeAliasDef (AliasCustomType (TypeName "Types.Time" []) (CustomTypeConstructor (TitleCaseDotPhrase "Int") [])) -}
decodeTypesTime : Json.Decode.Decoder (Types.Time)
decodeTypesTime  =
    (decodeInt)