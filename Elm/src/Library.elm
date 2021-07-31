module Library exposing (..)

-- Model
type AuthorName
  = Name String
  | Anonymous

type alias Book =
  { title : String
  , year : Int
  , author : AuthorName
  }

type alias Model =
  { books: List Book }

type Msg
  = Next
  | Prev
