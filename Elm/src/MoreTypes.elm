module MoreTypes exposing(..)

import Tuple as T
import List as L

-- Tuples

point : (Int, Int)
point = (1, 3)

rgb : (Int, Int, Int)
rgb = (255, 255, 0)

-- List

fruits : List String
fruits = ["apple", "orange", "pitahaya", "capuli"]

-- Type alias
type alias Point = (Int, Int)

p1 : Point
p1 = (6, 8)

-- Union types
type TrafficLight
  = Red
  | Yellow
  | Green

type Optional a
  = Some a
  | None

type Either a b
  = Left a
  | Right b

-- Records types
type alias Todo =
  { description : String
  , completed : Bool
  , tags : List String
  , priority : Optional Int
  }

--- Operations
-- Tuple

x = T.first point
y = T.second point
x1 = T.first p1
y1 = T.second p1

-- List
moreFruits = fruits ++ ["Jack fruit", "pear"]
oneToTen = L.range 1 10

-- Record
todo = Todo "Elm workshop" False ["TestingUy", "Elm"] None
desc = .description todo
tags = todo.tags
