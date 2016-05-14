port module Main exposing (..)

import Html.App as Html
import Html exposing (Html, div, text)

type alias Model =
  {}

type alias SubPort result msg = (result -> msg) -> Sub msg

{- TODO: Fill -}
type alias Entry =
  {}

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

port unlock : String -> Cmd msg
port readEntries : () -> Cmd msg
port fillEntry : Int -> Cmd msg

port unlocked : (Bool -> msg) -> Sub msg
port entries : (List Entry -> msg) -> Sub msg
port filled : (Bool -> msg) -> Sub msg

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
