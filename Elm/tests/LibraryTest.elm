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
      https://package.elm-lang.org/packages/elm/core/1.0.5/String#contains
      - Use E.true and E.false
      https://package.elm-lang.org/packages/elm-explorations/test/1.2.2/Expect#true
      https://package.elm-lang.org/packages/elm-explorations/test/1.2.2/Expect#false
-}

bookFixture : L.Book
bookFixture =
  { title = "Testing"
  , year = 2021
  , author = L.Anonymous
  , favorite = True
  }

fmtTitleTest : Test
fmtTitleTest =
  describe "fmtTitle"
  [ todo "Implement: contains star when favorite"
  , todo "Implement: not contains star when not favorite"
  ]

