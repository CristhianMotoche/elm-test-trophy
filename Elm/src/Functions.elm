module Functions exposing (..)

import List as L
import String as S

-- Named functions
-- Syntax:
{-
identifier : First Param -> Second Param -> ... -> Return Type
identifier = functionBody
-}

add20 : Int -> Int
add20 n = n + 20

divisibleBy5 : Int -> Bool
divisibleBy5 n = modBy n 5 == 0

prod : Int -> Int -> Int
prod a b = a * b

-- Anonymous functions

-- Syntax:
{-
\param1 param2 ... -> functionBody
-}

add : Int -> Int -> Int
add = \x y -> x + y


-- High Order Functions

numbers = [4, 5, 10, 32, 40, 201, 400]

-- map : (a -> b) -> List a -> List b
-- map f data ->
  -- Applies `f` on each element of `data` and generates a new structure
strNums = L.map S.fromInt numbers

-- filter : (a -> Bool) -> List a -> List a
-- filter p data ->
  -- Filter `data` where `p` is `True`
allDivisibleBy5 = L.filter divisibleBy5 numbers

-- foldl : (a -> b -> b) -> b -> List a -> b
-- foldl f init data | foldr f init data ->
  -- Folds `data` starting with `init` and applyting `f` on each pair
totalProd = L.foldl prod 0 numbers

--- If statements
addHash : String -> String
addHash str =
  if S.startsWith "#" str
  then str
  else "#" ++ str

--- Pattern matching
type TrafficLight
  = Red
  | Yellow
  | Green

canIContinue : TrafficLight -> Bool
canIContinue tfl =
  case tfl of
    Green -> True
    _ -> False
