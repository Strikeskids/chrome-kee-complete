module EntryList exposing
  ( Model, Msg(UpdateFilter), Filter
  , init, update, subscriptions, view )

import Html exposing ( text )

import KdbConnection exposing ( Entry )

type alias Filter = Entry -> Bool

type Msg
  = Nop
  | UpdateFilter Filter
  | 

type alias Model =
  { filter : Filter
  , entries : List Entry
  , filteredEntries : List Entry
  }

init : Filter -> (Model, Cmd Msg)
init f =
  (Model f [] []) ! []

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    Nop ->
      model ! []

    UpdateFilter f ->
      { model | filter = f } ! []

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    []

view : Model -> Html Msg
view model =
  text "hello"
