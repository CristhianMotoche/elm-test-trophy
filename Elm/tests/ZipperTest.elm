module ZipperTest exposing(..)

import Zipper exposing (Zip, watchList, next, prev, listNext, listPrev)
import Test exposing (Test, describe, test, fuzz)
import Expect as E
import Fuzz as F


empty = watchList []
zipper = watchList [1, 2, 3, 4, 5]

nextSuite : Test
nextSuite =
  describe "next"
  [ describe "given an empty zipper"
    [ test "zipper stays empty" <|
        \_ ->
          next empty
          |> E.equal empty
    ]
  , describe "given a non-empty zipper"
    [ test "next list is shorted" <|
        \_ ->
          next zipper
          |> listNext
          |> E.equal [3, 4, 5]
    ]
  ]

prevSuite : Test
prevSuite =
  describe "prev"
  [ describe "given an empty zipper"
    [ test "zipper stays empty" <|
        \_ ->
          prev empty |> E.equal empty
    ]
  , describe "given a non-empty zipper"
    [ test "prev list stays empty" <|
        \_ ->
          prev zipper
          |> listPrev
          |> E.equal []
    ]
  ]


moveSuite : Test
moveSuite =
  describe "prev and next"
  [ describe "given a non-empty zipper"
    [ test "going prev and next" <|
      \_ ->
        watchList [1,2,3]
        |> next
        |> next
        |> prev
        |> \z ->
          E.true "adds elments to both lists" <|
          listPrev z == [1] && listNext z == [3]
    ]
  ]


fuzzyTest : Test
fuzzyTest =
  describe "prev and zip"
  [ fuzz (F.list F.int)
    "going the same prev and next steps generates the same zipper" <|
    \list ->
      watchList list
      |> next
      |> next
      |> prev
      |> prev
      |> E.equal (watchList list)
  ]
