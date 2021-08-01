module Library exposing (..)

import Browser as B
import Html as H
import Html.Events as HE

{-
  Tareas:

  1. Mostrar el caracter `star` cerca del título cuando el libro es favorito.
    * Tip: String.fromChar : Char -> String
-}

star : Char
star = '⭐'

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
  , favorite : Bool
  }

type Msg
  = Next
  | Prev


init : Model
init =
  { books = [
    { title = "Iliada"
    , year = 0
    , author = Name "Homero"
    , favorite = True
    },
    { title = "Odisea"
    , year = 0
    , author = Name "Homero"
    , favorite = True
    },
    { title = "El libro que nunca escribí"
    , year = 2021
    , author = Anonymous
    , favorite = False
    },
    { title = "La rebelión de la granja"
    , year = 1945
    , author = Name "George Orwell"
    , favorite = False
    },
    { title = "Un mundo feliz"
    , year = 1932
    , author = Name "Aldous Huxley"
    , favorite = True
    }
  ]
  , start = 0
  }

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
    [ viewBookTitle book
    , H.p [][ H.text <| fmtByYear book.year  ]
    , H.i [][ H.text <| "By "++ authorToString book.author  ]
    ]

viewBookTitle : Book -> H.Html Msg
viewBookTitle { title, favorite } =
  H.h1 [][ H.text <| fmtTitle favorite title ]

fmtTitle : Bool -> String -> String
fmtTitle favorite title =
  if favorite
  then title ++ " " ++ String.fromChar star
  else title

fmtByYear : Int -> String
fmtByYear y =
  if y <= 0
  then "BC"
  else String.fromInt y


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

-- Main
main : Program () Model Msg
main =
  B.sandbox
    { init = init
    , update = update
    , view = view
    }
