module Visible exposing (Visible, startVisible, take, up, down, isEmpty, slice)

type alias Visible a =
  { max: Int
  , min: Int
  , list: List a
  }

startVisible : Int -> List a -> Visible a
startVisible n ls = Visible n 0 ls

take : Visible a -> List a
take { min, max, list } = slice min max list

up : Visible a -> Visible a
up v =
  { v |
    max =
      if v.max < List.length v.list
      then v.max + 1
      else v.max
  , min =
      if v.max < List.length v.list
      then v.min + 1
      else v.min
  }

down : Visible a -> Visible a
down v =
  { v |
    max =
      if v.min > 0
      then v.max - 1
      else v.max
  , min =
      if v.min > 0
      then v.min - 1
      else v.min
  }

isEmpty : Visible a -> Bool
isEmpty v = List.isEmpty v.list

slice : Int -> Int -> List a -> List a
slice start end list =
  List.drop start
  <| List.take end
  <| list
