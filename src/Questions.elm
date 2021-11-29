module Questions exposing (..)

questionsAndSuggestions =
    [ { question = "What are the translations of 'epistēmē' and 'dýnamis' into English, respectively? (Just guess!)"
      , duration = 30
      , suggestion = "epistēmē = knowledge, and dýnamis = power, ability. (Knowing one of hese should give full points.)"
      }
    , { question = "What is the difference between knowledge and belief?"
      , duration = 40
      , suggestion = "Traditionally, knowledge is said to be 'justified true belief' (JTB). In the context of logic, it is most important that it is 'true belief'. There may also be plausible additional criteria."
      }
    , { question = "What does it mean for a fact to be logically 'contingent'?"
      , duration = 30
      , suggestion = "It is possible, but not necessary."
      }
    , { question = "Give an equivalent formula to: 'It is not possible that p.'"
      , duration = 30
      , suggestion = "For example: It is necessary that not p; ..."
      }
    , { question = "How do we write that p will be the case after performing action a exactly 5 times?"
      , duration = 30
      , suggestion = "<a;a;a;a;a> p"
      }
    ]

oldQuestionsAndSuggestions =
    [ { question = "What is the difference between validity and truth?"
      , duration = 30
      , suggestion = "Validity is about arguments, truth about sentences; or: a valid argument does not necessarily have a true conclusion."
      }
    , { question = "Give an example of a tautology!"
      , duration = 30
      , suggestion = "There are many! For example, p or (not p); p iff (not (not p)); ..."
      }
    , { question = "Name a formula that is logically equivalent to 'p implies q'!"
      , duration = 30
      , suggestion = "For example, (not q) implies (not p); not (not (p implies q)); ..."
      }
    , { question = "How do you read V |= p?"
      , duration = 20
      , suggestion = "There are three correct answers: V makes p true; V satisfies p; V is a model of p. (One of them is enough for full points here.)"
      }
    , { question = "Give 2 desirable properties of a proof system!"
      , duration = 25
      , suggestion = "Soundness and completeness. (Both should be named for full points.)"
      }
    , { question = "Let's see what you have learned: What is the difference between validity and truth?"
      , duration = 40
      , suggestion = "Validity is about arguments, truth about sentences; or: a valid argument does not necessarily have a true conclusion."
      }
    , { question = "One more revision: Name a formula that is logically equivalent to 'p implies q'!"
      , duration = 40
      , suggestion = "For example, (not q) implies (not p); not (not (p implies q)); ..."
      }
    , { question = "How many different possible logical operations with three arguments are there?"
      , duration = 60
      , suggestion = "256. The two arguments create 2*2*2=8 situations to be considered, and an operator could assign either true or false (2 options) to any of these 4 situations, so there are 2^8=256 possible operators."
      }
    ]
