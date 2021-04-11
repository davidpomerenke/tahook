module View exposing (..)

import Dict exposing (Dict)
import Dict.Extra as Dict
import Element exposing (..)
import Element.Font as Font
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Events.Extra exposing (onEnter)
import List.Extra as List
import Loading exposing (..)
import Material.Button as Button
import Material.Card as Card
import Material.Checkbox as Checkbox
import Material.Dialog as Dialog
import Material.Drawer.Modal as ModalDrawer
import Material.Elevation as Elevation
import Material.FormField as FormField
import Material.Icon as Icon
import Material.IconButton as IconButton
import Material.LayoutGrid as LayoutGrid
import Material.LinearProgress as LinearProgress
import Material.List as List
import Material.List.Item as ListItem
import Material.Menu as Menu
import Material.Radio as Radio
import Material.Switch as Switch
import Material.TextField as TextField
import Material.TextField.Icon as TextFieldIcon
import Material.Theme as Theme
import Material.TopAppBar as TopAppBar
import Material.Typography as Typography
import Maybe
import Maybe.Extra as Maybe
import Shared exposing (..)
import Types exposing (..)


view : Model -> { title : String, body : List (Html Msg) }
view model =
    { title = "Tahook"
    , body =
        [ case model.role of
            NotSelected ->
                roleSelection model

            _ ->
                app model
        ]
    }


roleSelection : Model -> Html Msg
roleSelection model =
    layout []
        (let
            card a =
                el
                    [ Element.width fill ]
                    (el [ centerX, centerY ]
                        (html
                            (Card.card
                                (Card.config
                                    |> Card.setOutlined True
                                    |> Card.setAttributes
                                        [ Elevation.z8
                                        , style "padding" "16px"
                                        ]
                                )
                                a
                            )
                        )
                    )
         in
         column
            [ centerX
            , centerY
            , spacing 50
            , Element.width (fill |> maximum 800)
            ]
            [ el
                [ Font.family [ Font.typeface "Bangers" ]
                , Font.size 100
                , centerX
                ]
                (Element.text "Tahook")
            , card
                { blocks =
                    [ Card.block
                        (TextField.outlined
                            (TextField.config
                                |> TextField.setLabel (Just "Quiz Name")
                                |> TextField.setValue model.typedHost
                                |> TextField.setOnInput HostTyped
                                |> TextField.setAttributes [ style "width" "300px", onEnter QuizJoinRequested ]
                            )
                        )
                    , Card.block
                        (Button.raised
                            (Button.config
                                |> Button.setDisabled (model.typedHost == Nothing || model.typedHost == Just "")
                                |> Button.setOnClick QuizJoinRequested
                                |> Button.setAttributes [ style "width" "300px" ]
                            )
                            "Join Quiz"
                        )
                    ]
                , actions = Nothing
                }
            , card
                { blocks =
                    [ Card.block
                        (div
                            (style "font-size" "16"
                                :: style "height" "56px"
                                :: centered
                            )
                            [ Html.text "Create a quiz and share it with others." ]
                        )
                    , Card.block
                        (div []
                            [ Button.raised
                                (Button.config
                                    |> Button.setOnClick QuizHosted
                                    |> Button.setAttributes [ style "width" "300px" ]
                                )
                                "Host Quiz"
                            ]
                        )
                    ]
                , actions = Nothing
                }
            , htmlCenter
                (Button.text
                    (Button.config
                        |> Button.setHref (Just "https://github.com/davidpomerenke/tahook")
                        |> Button.setTarget (Just "_blank")
                    )
                    "About"
                )
            ]
        )


centered =
    [ style "display" "flex"
    , style "justify-content" "center"
    , style "align-items" "center"
    ]


app : Model -> Html Msg
app model =
    div [ Typography.typography ]
        [ TopAppBar.regular (TopAppBar.config |> TopAppBar.setFixed True)
            [ TopAppBar.row []
                [ TopAppBar.section [ TopAppBar.alignStart ]
                    [ IconButton.iconButton
                        (IconButton.config
                            |> IconButton.setAttributes [ TopAppBar.navigationIcon ]
                            |> IconButton.setOnClick ShowDrawer
                        )
                        (IconButton.icon "menu")
                    , span [ TopAppBar.title ] [ Html.text "Tahook" ]
                    ]
                , TopAppBar.section [ TopAppBar.alignEnd ]
                    [ case model.role of
                        Host _ guests ->
                            Button.outlined
                                (Button.config
                                    |> Button.setAttributes [ Theme.onPrimary ]
                                    |> Button.setIcon (Just (Button.icon "groups"))
                                )
                                (String.fromInt (List.length guests) ++ " guests")

                        _ ->
                            Html.text ""
                    , Button.text
                        (Button.config
                            |> Button.setAttributes [ Theme.onPrimary ]
                            |> Button.setIcon (Just (Button.icon "account_circle"))
                        )
                        model.name
                    ]
                ]
            ]
        , div
            [ style "display" "flex"
            , style "flex-flow" "row nowrap"
            ]
            [ ModalDrawer.drawer
                (ModalDrawer.config
                    |> ModalDrawer.setOpen model.drawerShown
                    |> ModalDrawer.setOnClose HideDrawer
                )
                [ ModalDrawer.content []
                    [ List.list List.config
                        (ListItem.listItem (ListItem.config |> ListItem.setOnClick ShowHome)
                            [ Html.text "Quiz" ]
                        )
                        [ ListItem.listItem (ListItem.config |> ListItem.setOnClick ShowQuestions)
                            [ Html.text "Questions" ]
                        , ListItem.listItem (ListItem.config |> ListItem.setOnClick ShowChat)
                            [ Html.text "Chat" ]
                        ]
                    ]
                ]
            , ModalDrawer.scrim [] []
            , div
                [ TopAppBar.fixedAdjust, fillWidth ]
                [ layout
                    [ Element.width fill
                    , padding 20
                    , spacing 50
                    , Font.size 16
                    ]
                    (el [ centerX, Element.width (fill |> maximum 800) ] (content model))
                ]
            ]
        ]


fillWidth =
    style "width" "100%"


content : Model -> Element Msg
content model =
    case model.page of
        HomePage ->
            quizView model

        QuestionsPage ->
            case model.role of
                Host _ _ ->
                    column [ Element.width fill ]
                        [ case model.questions of
                            h :: t ->
                                html
                                    (List.list (List.config |> List.setAttributes [ fillWidth ])
                                        (questionToListItem h)
                                        (List.map questionToListItem t)
                                    )

                            _ ->
                                none
                        , html
                            (TextField.outlined
                                (TextField.config
                                    |> TextField.setValue (Just model.typedQuestion)
                                    |> TextField.setOnInput QuestionTyped
                                    |> TextField.setAttributes
                                        [ onEnter QuestionSubmitted
                                        , style "width" "100%"
                                        ]
                                    |> TextField.setTrailingIcon
                                        (Just
                                            (TextFieldIcon.icon "add"
                                                |> TextFieldIcon.setOnInteraction QuestionSubmitted
                                            )
                                        )
                                )
                            )
                        ]

                _ ->
                    paragraph [] [ Element.text "In a future version it will be possible for guests to contribute questions." ]

        ChatPage ->
            column [ Element.width fill ]
                [ html
                    (div
                        [ id "chat"
                        , style "max-height" "300px"
                        , style "overflow" "scroll"
                        , style "width" "100%"
                        ]
                        (case model.chat of
                            h :: t ->
                                [ List.list (List.config |> List.setTwoLine True)
                                    (chatToListItem h)
                                    (List.map chatToListItem t)
                                ]

                            _ ->
                                []
                        )
                    )
                , html
                    (TextField.outlined
                        (TextField.config
                            |> TextField.setValue (Just model.typedChat)
                            |> TextField.setOnInput ChatTyped
                            |> TextField.setAttributes
                                [ onEnter ChatSubmitted
                                , style "width" "100%"
                                ]
                            |> TextField.setTrailingIcon
                                (Just (TextFieldIcon.icon "send" |> TextFieldIcon.setOnInteraction ChatSubmitted))
                        )
                    )
                ]


quizView model =
    column [ Element.width fill, spacing 100 ]
        [ case ( model.role, model.quiz ) of
            ( Host _ _, NotStarted ) ->
                column [ Element.width fill, spacing 50 ]
                    [ paragraph []
                        [ Element.text "Invite folks by telling them your name, "
                        , el [ Font.bold ] (Element.text model.name)
                        , Element.text "!"
                        ]
                    , htmlCenter
                        (div []
                            [ Button.raised
                                (Button.config
                                    |> Button.setOnClick NextQuestionClick
                                )
                                "Start quiz!"
                            ]
                        )
                    ]

            ( Host _ _, Question _ _ ) ->
                none

            ( Host _ _, Rating _ _ ) ->
                column [ Element.width fill, spacing 50 ]
                    [ Element.text "Peer grading is taking place."
                    , htmlCenter
                        (Button.raised
                            (Button.config
                                |> Button.setOnClick NextQuestionClick
                            )
                            "Next question!"
                        )
                    ]

            ( Host _ _, Loading _ ) ->
                Element.text "Loading"

            ( Host _ _, Finished ) ->
                none

            _ ->
                none
        , el [ centerX, Element.width fill ]
            (case model.quiz of
                NotStarted ->
                    paragraph [] [ Element.text "Waiting for the host to start the quiz." ]

                Question due q ->
                    model.time
                        |> Maybe.map (\time -> htmlFill (questionCard (due - time) q model))
                        |> Maybe.withDefault none

                Loading q ->
                    column [ Element.width fill, spacing 50 ]
                        [ htmlFill (questionCard 0 q model)
                        , paragraph [] [ Element.text "Waiting for the peer grading to start." ]
                        ]

                Rating q peerAnswers ->
                    column [ Element.width fill, spacing 50 ]
                        ((case model.role of
                            Guest _ ->
                                htmlFill (questionCard 0 q model)

                            _ ->
                                none
                         )
                            :: List.map (\a -> htmlFill (ratingCard a q)) (Dict.toList peerAnswers)
                        )

                Finished ->
                    paragraph [] [ Element.text "The quiz has finished, and the winner(s) will be shown here once this feature is implemented." ]
            )
        , case model.role of
            Host history _ ->
                column [ Element.width fill, spacing 50 ]
                    (case List.sortBy (\( _, { order } ) -> -order) (Dict.toList history) of
                        h :: t ->
                            htmlFill (historyCard [ Elevation.z8 ] h)
                                :: List.map (\a -> htmlFill (historyCard [ Elevation.z4 ] a)) t

                        _ ->
                            []
                    )

            _ ->
                none
        ]


htmlFill a =
    el [ Element.width fill ] (html a)


htmlCenter a =
    el [ centerX ] (html a)


historyCard attrs ( question, { answers } ) =
    Card.card
        (Card.config
            |> Card.setAttributes (fillWidth :: attrs)
        )
        { blocks =
            [ Card.block
                (div [ style "margin" "30px" ]
                    [ Html.text question
                    , let
                        nAnswers =
                            Dict.size answers
                      in
                      case Dict.toList answers of
                        h :: t ->
                            List.list List.config
                                (historyListItem nAnswers h)
                                (List.map (historyListItem nAnswers) t)

                        _ ->
                            Html.text ""
                    ]
                )
            ]
        , actions = Nothing
        }


historyListItem nAnswers ( name, { answer, ratings } ) =
    ListItem.listItem ListItem.config
        [ ListItem.text []
            { primary = [ Html.text answer ]
            , secondary = [ Html.text name ]
            }
        , ListItem.meta []
            (List.map
                (\( _, r ) ->
                    Icon.icon []
                        (case r of
                            0 ->
                                "sentiment_very_dissatisfied"

                            2 ->
                                "sentiment_satisfied_alt"

                            _ ->
                                "sentiment_neutral"
                        )
                )
                (Dict.toList ratings)
                ++ List.repeat (nGraders nAnswers - Dict.size ratings)
                    (Icon.icon [] "radio_button_unchecked")
            )
        ]


questionCard progress q model =
    Card.card
        (Card.config |> Card.setAttributes [ fillWidth, Elevation.z8 ])
        { blocks =
            [ Card.block
                (div [ onClick AnswerFocused ]
                    [ let
                        progress_ =
                            toFloat (Basics.max 0 progress) / questionDuration
                      in
                      div
                        [ style "background-color" "blue"
                        , style "height" "3px"
                        , style "width" (String.fromFloat (100 * progress_) ++ "%")
                        ]
                        []
                    , div [ style "margin" "30px" ] [ Html.text q ]
                    , case model.role of
                        Guest _ ->
                            TextField.filled
                                (TextField.config
                                    |> TextField.setValue (Just model.typedAnswer)
                                    |> TextField.setOnInput AnswerTyped
                                    |> TextField.setFullwidth True
                                    |> TextField.setAttributes [ style "padding" "0px 30px", id "answer-field" ]
                                    |> TextField.setPlaceholder (Just "Type your answer here ...")
                                    |> TextField.setDisabled
                                        (case model.quiz of
                                            Question _ _ ->
                                                False

                                            _ ->
                                                True
                                        )
                                )

                        _ ->
                            Html.text ""
                    ]
                )
            ]
        , actions = Nothing
        }


questionToListItem a =
    ListItem.listItem ListItem.config
        [ Html.text a
        , ListItem.meta [ onClick (QuestionRemoved a) ] [ Icon.icon [] "remove_circle_outline" ]
        ]


ratingCard ( peer, { answer, rating } ) q =
    Card.card
        (Card.config |> Card.setAttributes [ fillWidth, Elevation.z4 ])
        { blocks =
            [ Card.block
                (div [ style "margin" "30px" ]
                    [ Html.text answer
                    , div [ style "justify-content" "space-between" ]
                        [ ratingRadio q peer rating 0 "Not really"
                        , ratingRadio q peer rating 1 "Kind of"
                        , ratingRadio q peer rating 2 "Yes exactly"
                        ]
                    ]
                )
            ]
        , actions = Nothing
        }


ratingRadio q peer rating number label =
    FormField.formField
        (FormField.config
            |> FormField.setLabel (Just label)
            |> FormField.setOnClick (Rated number peer q)
        )
        [ Radio.radio
            (Radio.config
                |> Radio.setOnChange (Rated number peer q)
                |> Radio.setChecked (rating == Just number)
            )
        ]


chatToListItem item =
    ListItem.listItem ListItem.config
        [ ListItem.text []
            { primary = [ Html.text item.content ]
            , secondary = [ Html.text item.name ]
            }
        ]


nameToListItem : ( String, Maybe String ) -> ListItem.ListItem msg
nameToListItem ( id, name ) =
    ListItem.listItem ListItem.config
        [ ListItem.graphic [] [ Icon.icon [] "account_circle" ]
        , ListItem.text []
            { primary = [ Html.text (Maybe.withDefault "Anonymous User" name) ]
            , secondary = [ Html.text id ]
            }
        ]
