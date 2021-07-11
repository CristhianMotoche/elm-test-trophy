module Zipper exposing (Zip, watchList, next, prev, listPrev, listNext)


type Zip a
  = Current (List a) a (List a)
  | Empty

watchList : List a -> Zip a
watchList list =
  case list of
    [] -> Empty
    x :: xs ->  Current [] x xs

next : Zip a -> Zip a
next z =
  case z of
    Empty -> Empty
    Current ps x [] -> z
    Current ps x (n::ns) ->
      Current (ps ++ [x]) n ns

prev : Zip a -> Zip a
prev z =
  case z of
    Empty -> Empty
    Current ps x ns ->
      case last ps of
        Nothing -> z
        Just v -> Current (firsts ps) v (x::ns)

last : List a -> Maybe a
last l =
  case l of
    [] -> Nothing
    (x :: []) -> Just x
    (x :: xs) -> last xs

firsts : List a -> List a
firsts l =
  case l of
    [] -> []
    (x :: []) -> []
    (x :: xs) -> x :: firsts xs

listPrev : Zip a -> List a
listPrev z =
  case z of
    Empty -> []
    Current ls _ _ -> ls

listNext : Zip a -> List a
listNext z =
  case z of
    Empty -> []
    Current _ _ ls-> ls
