module LibraryTest exposing (..)

import Test exposing (..)
import Expect as E
import Library as L
import Fuzz as F

fmtByYearTest : Test
fmtByYearTest =
  describe "fmtByYear"
  [ test "returns BC when year below 0" <|
    \_ ->
      L.fmtByYear -5
      |> E.equal "BC"
  , test "returns year when year over 0" <|
    \_ ->
      L.fmtByYear 2021
      |> E.equal "2021"
  ]

sliceFuzzTest : Test
sliceFuzzTest =
  describe "slice fuzz tests"
  [ fuzz2 (F.list F.int) F.int "when index is the same it returns and empty list" <|
    \list idx ->
      L.slice idx idx list
      |> E.equal []
  ]
