module ZipperTest exposing(..)

import Zipper exposing (Zip, watchList, next, prev, listNext, listPrev)
import Test exposing (Test, describe, test)
import Expect as E


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
        next zipper
        |> next
        |> next
        |> prev
        |> listPrev
        |> E.equal [1, 2]
    ]
  ]
