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
  { bookLP | title = "Plagia Little prince", author = Anonymous, year = 2000 }

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

-- Some functions
isOld : Int -> Bool
isOld y = y < 1950

-- if ... then ... else ...

formatByYear : Int -> String
formatByYear y =
  if isOld y
  then "Classic"
  else "Contemporary"

-- Pattern matching

fmtAuthor : Author -> String
fmtAuthor author =
  case author of
    Name name -> name
    _ -> "Anonymous"

-- Currying

fmtBook_ : Author -> Int -> String -> String
fmtBook_ author year title =
  title ++ " by " ++ fmtAuthor author ++ " is a " ++ formatByYear year ++ " book"

fmtAnonymous : Int -> String -> String
fmtAnonymous = fmtBook_ Anonymous

fmtAnonymousClassic : String -> String
fmtAnonymousClassic = fmtAnonymous 1900

-- Destructuring records

fmtBook : Book -> String
fmtBook {title, year, author} =
  title ++ " by " ++ fmtAuthor author ++ " is a " ++ formatByYear year ++ " book"

-- Anonymous Functions and High order functions
--- map
booksFormatted : List String
booksFormatted = List.map fmtBook books

--- filter
classicBooks : List Book
classicBooks = List.filter (\book -> isOld book.year) books

-- reduce (foldl && foldr)
fmtBook2 : Book -> String
fmtBook2 {title, year, author} =
  List.foldr (++) ""
    [title, " by ", fmtAuthor author, " is a ", formatByYear year, " book"]
