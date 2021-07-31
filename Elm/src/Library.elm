module Library exposing (..)

import Html as H
import Html.Events as HE

-- Model
type alias Model =
  { books: List Book
  , start : Int
  }

type AuthorName
  = Name String
  | Anonymous

type alias Book =
  { title : String
  , year : Int
  , author : AuthorName
  }

type Msg
  = Next
  | Prev


-- View
view : Model -> H.Html Msg
view model =
  H.div
  []
  <| List.map viewBook (slice model.start (model.start + 3) model.books) ++ [viewActions]

viewActions : H.Html Msg
viewActions =
    H.div
    []
    [ H.button [ HE.onClick Prev  ][ H.text "Prev"  ]
    , H.button [ HE.onClick Next  ][ H.text "Next"  ]
    ]

viewBook : Book -> H.Html Msg
viewBook book =
    H.div
    []
    [ H.h1 [][ H.text book.title  ]
    , H.p [][ H.text <| String.fromInt book.year  ]
    , H.i [][ H.text <| "By "++ authorToString book.author  ]
    ]

authorToString : AuthorName -> String
authorToString author =
  case author of
    Name name -> name
    Anonymous -> "Anonymous"

slice : Int -> Int -> List a -> List a
slice start end list =
  List.drop start
  <| List.take end
  <| list

-- Update
update : Msg -> Model -> Model
update msg model =
  case msg of
    Next ->
      { model | start =
          if model.start < List.length model.books - 3
          then model.start + 1
          else model.start
     }
    Prev ->
     { model | start =
         if model.start > 0
         then model.start - 1
         else model.start
     }
