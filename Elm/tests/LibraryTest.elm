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


{-
Tareas:
  1. Agregar un par de pruebas para `fmtTitle`
    * Tips:
      - Use String.contains to check if L.star is present
      - Use E.true and E.false
-}


fmtTitleTest : Test
fmtTitleTest =
  describe "fmtTitle"
  [ test "contains star when favorite" <|
    \_ ->
      L.fmtTitle True "Bubbles"
      |> String.contains (String.fromChar L.star)
      |> E.true "should contain star"
  , test "not contains star when not favorite" <|
    \_ ->
      L.fmtTitle False "Hello world!"
      |> String.contains (String.fromChar L.star)
      |> E.false "should not contain star"
  ]

