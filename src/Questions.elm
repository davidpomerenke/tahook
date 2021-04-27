module Questions exposing (..)


questionsAndSuggestions =
    [ { question = "What is the difference between validity and truth?"
      , duration = 40
      , suggestion = "Validity is about arguments, truth about sentences; or: a valid argument does not necessarily have a true conclusion."
      }
    , { question = "Give an example of a tautology!"
      , duration = 40
      , suggestion = "There are many! For example, p or (not p); p iff (not (not p)); ..."
      }
    , { question = "Name a formula that is logically equivalent to 'p implies q'!"
      , duration = 40
      , suggestion = "For example, (not q) implies (not p); not (not (p implies q)); ..."
      }
    , { question = "How do you read V |= p?"
      , duration = 30
      , suggestion = "There are three correct answers: V makes p true; V satisfies p; V is a model of p. (One of them is enough for full points here.)"
      }
    , { question = "Give 2 desirable properties of a proof system!"
      , duration = 30
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
    , { question = "How many different possible logical operations with two arguments are there?"
      , duration = 60
      , suggestion = "16. The two arguments create 2*2=4 situations to be considered, and an operator could assign either true or false (2 options) to any of these 4 situations, so there are 2^4=16 possible operators."
      }
    ]
