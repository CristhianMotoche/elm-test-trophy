module GalleryTest exposing (..)


import Gallery as G
import Test exposing (Test, test, describe)
import ProgramTest as PT
import Expect as E
import Json.Encode as JE
import Json.Decode as JD
import Test.Html.Selector as S
import SimulatedEffect.Cmd as SCmd
import SimulatedEffect.Http as SHttp

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
    ]
  ]
