module LibraryTest exposing (..)

import Test exposing (..)
import Expect as E
import Library as L
import Fuzz as F
import ProgramTest as PT
import Test.Html.Selector as H

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
  ]
