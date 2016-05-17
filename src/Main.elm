import Html.App as App
import Html exposing (Html, div, text)

import KdbConnection exposing ( Entry )
import Unlocker

main = App.program 
  { init = init
  , update = update
  , subscriptions = subscriptions
  , view = view
  }

type alias Model =
  { unlocked : Bool
  , unlocker : Unlocker.Model
  }

init : (Model, Cmd Msg)
init =
  let
    (unlocker, ucmd) = Unlocker.init
  in
    ( Model
        False
        unlocker
    )
    !
    [ Cmd.map UnlockerMsg ucmd
    ]

type Msg
  = Nop
  | DatabaseUnlocked
  | DatabaseLocked
  | UnlockerMsg Unlocker.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    Nop ->
      model ! []

    DatabaseUnlocked ->
      { model | unlocked = True } ! []

    DatabaseLocked ->
      { model | unlocked = False } ! []

    UnlockerMsg msg ->
      let
        (newUnlocker, cmd) = Unlocker.update msg model.unlocker
      in
        { model | unlocker = newUnlocker } ! [ Cmd.map UnlockerMsg cmd ]

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ KdbConnection.subscriptions
        Nop
        (\x -> if x then DatabaseUnlocked else DatabaseLocked)
        (always Nop)
        (always Nop)
    ]

view : Model -> Html Msg
view model =
  if not model.unlocked then
    Unlocker.view model.unlocker
      |> App.map UnlockerMsg

  else
    text "Hello World"
