module LibraryTest exposing (..)

import Test exposing (..)
import Expect as E
import Library as L
import Fuzz as F
import ProgramTest as PT
import Test.Html.Selector as H
import Test.Html.Query as Q

-- Unit test

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

-- Integration tests
app : PT.ProgramTest L.Model L.Msg ()
app =
  PT.createSandbox {
    init = L.init
  , view = L.view
  , update = L.update
  }
  |> PT.start ()

{-
Tareas:
  1. Agregar una prueba para el evento FilterFavs
   Tips:
    - Use `PT.expectView` and the `containStars` helper
    https://package.elm-lang.org/packages/avh4/elm-program-test/latest/ProgramTest#expectView
  2. Agregar una prueba para el evento Restore
   Tips:
    - Use `PT.ensureView` and the helpers: `containBooks` and `containStars`
    https://package.elm-lang.org/packages/avh4/elm-program-test/latest/ProgramTest#ensureView
-}

libraryTest : Test
libraryTest =
  describe "Library"
  [ test "when loaded shows Next and Prev buttons" <|
    \_ ->
      app
      |> PT.expectViewHas [ H.text "Prev", H.text "Next" ]
  , test "when click on Next shows 4th book" <|
    \_ ->
      app
      |> PT.clickButton "Next"
      |> PT.expectViewHas [ H.text "granja" ]
  , test "when click on Next hides 1st book" <|
    \_ ->
      app
      |> PT.clickButton "Next"
      |> PT.expectViewHasNot [ H.text "Iliada" ]
  , test "when click on Next and Prev showa 1st book" <|
    \_ ->
      app
      |> PT.clickButton "Next"
      |> PT.clickButton "Prev"
      |> PT.expectViewHas [ H.text "Iliada" ]
  ,
    let
      containStars view =
        view
        |> Q.findAll [ H.text <| String.fromChar L.star ]
        |> Q.count (E.equal 3)
    in
      todo "Implement: click on Favorites filters favorite books"
  ,
    let
      containBooks view =
        view
        |> Q.findAll [ H.tag "h1" ]
        |> Q.count (E.equal 3)
      containStars view =
        view
        |> Q.findAll [ H.text <| String.fromChar L.star ]
        |> Q.count (E.atMost 2)
    in
      todo "Implement: click on Restore"
  ]
