module Library exposing (..)

bookLP : Book
bookLP = 
  { title = "The Little Prince"
  , synopsis = "This is the story of a little prince from another planet"
  , year = 1943
  , author = Name "Anotine de S."
  }

someBook : Book
someBook =
  { bookLP | title = "Plagia Little prince", author = Anonymous }

books : List Book
books = [bookLP, someBook]

type Author
  = Name String
  | Anonymous

type alias Book =
  { title : String
  , synopsis : String
  , year : Int
  , author : Author
  }
