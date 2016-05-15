port module Main exposing (..)

import Html.App as Html
import Html exposing (Html, div, text)

type alias Model =
  {}

{- TODO: Fill -}
type alias Entry =
  { uuid : String
  , fields : }

type Msg
  = Cry

main = Html.program 
  { init = init
  , update = update
  , subscriptions = subscriptions
  , view = view
  }

model = {}

init : (Model, Cmd Msg)
init =
  (model, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    Cry ->
      ( model, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

view : Model -> Html Msg
view model =
  div [] [text "Hello World"]
