module Gallery exposing (..)

import Http
import Html as H
import Html.Events as HE
import Browser as B
import Json.Decode as D
import Json.Encode as E

-- Model
type alias Model =
  { books: List Book
  , start : Int
  , errors : List String
  , loading : Bool
  }

type AuthorName
  = Name String
  | Anonymous

type alias Book =
  { title : String
  , synopsis : String
  , author : AuthorName
  }

-- Eff

type Eff
  = NoOp
  | GetBookList
    { url: String
    , onResult: Result Http.Error (List Book) -> Msg
    }

run : Eff -> Cmd Msg
run eff =
  case eff of
    NoOp -> Cmd.none
    GetBookList { url, onResult } ->
      Http.get
      { url = url
      , expect = Http.expectJson onResult (D.list bookDecoder)
      }

-- JSON

bookDecoder : D.Decoder Book
bookDecoder =
  D.map3 Book
    (D.field "title" D.string)
    (D.field "synopsis" D.string)
    (D.field "author" authorNameDecoder)

authorNameDecoder : D.Decoder AuthorName
authorNameDecoder =
  D.oneOf
    [ D.map Name D.string
    , D.null Anonymous
    ]

bookEncoder : Book -> E.Value
bookEncoder book =
  E.object
    [ ("title", E.string book.title)
    , ("synopsis", E.string book.synopsis)
    , ("author", authorNameEncoder book.author)
    ]

authorNameEncoder : AuthorName -> E.Value
authorNameEncoder an =
  case an of
    Name name -> E.string name
    _ -> E.null


-- HTTP

getBooks : Eff
getBooks =
  GetBookList
  { url = "http://localhost:3000/books"
  , onResult = GetBooks
  }

-- Init

init : (Model, Eff)
init =
  ({ books = []
  , start = 0
  , errors = []
  , loading = True
  }, getBooks )

type Msg
  = Next
  | Prev
  | GetBooks (Result Http.Error (List Book))

slice : Int -> Int -> List a -> List a
slice start end list =
  List.drop start
  <| List.take end
  <| list

-- View
view : Model -> H.Html Msg
view model =
  H.div
    []
    <|
    case (model.loading, model.errors) of
      (True, _) -> [ H.text "Loading..." ]
      (_, []) -> List.map viewBook (slice model.start (model.start + 3) model.books) ++ [viewActions]
      (_, errors) -> List.map H.text errors

viewActions : H.Html Msg
viewActions =
  H.div
    []
    [ H.button [ HE.onClick Prev ][ H.text "Prev" ]
    , H.button [ HE.onClick Next ][ H.text "Next" ]
    ]

viewBook : Book -> H.Html Msg
viewBook book =
  H.div
    []
    [ H.h1 [][ H.text book.title ]
    , H.p [][ H.text book.synopsis ]
    , H.i [][ H.text <| "By "++ authorToString book.author ]
    ]

authorToString : AuthorName -> String
authorToString author =
  case author of
    Name name -> name
    Anonymous -> "Anonymous"


-- Update
update : Msg -> Model -> (Model, Eff)
update msg model =
  case msg of
    Next ->
      ({ model | start =
        if model.start < List.length model.books - 3
           then model.start + 1
           else model.start
      }, NoOp)
    Prev ->
      ({ model | start =
        if model.start > 0
           then model.start - 1
           else model.start
       }, NoOp)
    GetBooks (Ok books)->
      ({ model
       | books = books, errors = [], loading = False }
       , NoOp)
    GetBooks _->
      ({ model
       | books = [], errors = ["Could not get books"], loading = False }
       , NoOp)

main : Program () Model Msg
main =
  B.element
    { init =
        \_ -> init |> Tuple.mapSecond run
    , update =
        \model msg ->
          update model msg |> Tuple.mapSecond run
    , view = view
    , subscriptions = \_ -> Sub.none
    }
