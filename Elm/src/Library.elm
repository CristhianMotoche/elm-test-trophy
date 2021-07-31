module Library exposing (..)

-- Model
type alias Model =
  { books: List Book
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
