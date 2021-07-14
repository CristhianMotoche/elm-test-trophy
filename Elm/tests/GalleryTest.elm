module GalleryTest exposing (..)


import Gallery as G
import Test exposing (Test, test, describe)
import ProgramTest as PT
import Expect as E
import Test.Html.Selector as S
import SimulatedEffect.Http as SHttp


start : PT.ProgramTest G.Model G.Msg (Cmd G.Msg)
start =
  PT.createElement
  { init = \_ -> G.init
  , view = G.view
  , update = G.update
  }
  |> PT.start ()


galleryTest : Test
galleryTest =
  describe "Gallery"
  [ describe "when API returns initial values"
    [ test "shows initial three books" <|
      \_ ->
        start
        |> PT.expectViewHas [ S.text "Loading..." ]
    ]
  ]
