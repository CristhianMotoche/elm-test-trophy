module GalleryTest exposing (..)


import Gallery as G
import Test exposing (Test, test, describe, fuzz, fuzz2)
import ProgramTest as PT
import Expect as E
import Fuzz as F
import Json.Encode as JE
import Json.Decode as JD
import Test.Html.Selector as S
import SimulatedEffect.Cmd as SCmd
import SimulatedEffect.Http as SHttp

-- Unit tests
sliceTest : Test
sliceTest =
  describe "slice"
  [ describe "when the list is empty"
    [ test "returns an empty list" <|
      \_ ->
        G.slice 0 1 [] |> E.equal []
    ]
  , describe "when the list has values"
    [ test "returns first elements" <|
      \_ ->
        G.slice 3 5 [1,2,3,4,5] |> E.equal [4,5]
    , test "returns empty lists on the same index" <|
      \_ ->
        G.slice 3 3 [1,2,3,4,5] |> E.equal []
    , test "returns empty lists on the start < end" <|
      \_ ->
        G.slice 3 1 [1,2,3,4,5] |> E.equal []
    ]
  ]

sliceFuzzyTest : Test
sliceFuzzyTest =
  describe "fuzzy slice"
  [ fuzz (F.list F.int) "returns the whole list on 0 and length" <|
    \list ->
      G.slice 0 (List.length list) list |> E.equal list
  , fuzz2 F.int (F.list F.int) "returns empty list on same index" <|
    \idx list ->
      G.slice idx idx list |> E.equal []
  ]

-- Integration tests

fixture : G.Book
fixture =
  { author = G.Anonymous
  , synopsis = "testing"
  , title = "Test"
  }

runEff : G.Eff -> PT.SimulatedEffect G.Msg
runEff eff =
  case eff of
    G.NoOp -> SCmd.none
    G.GetBookList { url, onResult } ->
      SHttp.get
        { url = url, expect = SHttp.expectJson onResult (JD.list G.bookDecoder) }

start : PT.ProgramTest G.Model G.Msg G.Eff
start =
  PT.createElement
  { init = \_ -> G.init
  , view = G.view
  , update = G.update
  }
  |> PT.withSimulatedEffects runEff
  |> PT.start ()


galleryTest : Test
galleryTest =
  describe "Gallery"
  [ describe "when API returns initial values"
    [ test "shows initial three books" <|
      \_ ->
        start
        |> PT.simulateHttpOk
           "GET"
           "http://localhost:3000/books"
           (JE.encode 0 <| JE.list G.bookEncoder [fixture])
        |> PT.expectViewHas [ S.text fixture.title ]
    ],
    describe "when API returns an empty list"
    [ test "shows message" <|
      \_ ->
        start
        |> PT.simulateHttpOk
           "GET"
           "http://localhost:3000/books"
           (JE.encode 0 <| JE.list G.bookEncoder [])
        |> PT.expectViewHas [ S.text "No books" ]
    ],
    describe "when clicking on Next view"
    [ test "shows newest book" <|
      \_ ->
        start
        |> PT.simulateHttpOk
           "GET"
           "http://localhost:3000/books"
           (JE.encode 0 <| JE.list G.bookEncoder [fixture, fixture, fixture, { fixture | title = "New book" }])
        |> PT.clickButton "Next"
        |> PT.expectViewHas [ S.text "New book" ]
    , test "hides oldest book" <|
      \_ ->
        start
        |> PT.simulateHttpOk
           "GET"
           "http://localhost:3000/books"
           (JE.encode 0 <| JE.list G.bookEncoder [{ fixture | title = "New book" }, fixture, fixture, fixture])
        |> PT.clickButton "Next"
        |> PT.expectViewHasNot [ S.text "New book" ]
    ],
    describe "when clicking Next and Prev"
    [ test "shows oldest book" <|
      \_ ->
        start
        |> PT.simulateHttpOk
           "GET"
           "http://localhost:3000/books"
           (JE.encode 0 <| JE.list G.bookEncoder [{ fixture | title = "New book" }, fixture, fixture, fixture])
        |> PT.clickButton "Next"
        |> PT.clickButton "Prev"
        |> PT.expectViewHas [ S.text "New book" ]
    ]
  ]
