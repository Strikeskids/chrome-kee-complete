module Unlocker exposing
  ( Model, Msg, init, update, view, subscriptions
  )

import Html exposing ( Html, form, input, button, text )
import Html.Events exposing ( onSubmit, onInput )
import Html.Attributes exposing ( type', autofocus, classList, value )
import KdbConnection

type Validity = Unknown | Valid | Invalid

type alias Model =
  { recentValidity : Validity
  , password : String
  }

init : (Model, Cmd Msg)
init =
  (Model Unknown "") ! []

type Msg
  = Nop
  | InvalidPassword
  | ValidPassword
  | PasswordValue String
  | SubmitPassword

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    Nop ->
      model ! []

    InvalidPassword ->
      { model | recentValidity = Invalid } ! []

    ValidPassword ->
      { model
        | recentValidity = Valid
        , password = ""
      } ! []

    SubmitPassword ->
      model ! [ KdbConnection.unlock model.password ]

    PasswordValue s ->
      { model
        | recentValidity = Unknown
        , password = s
      } ! []

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ KdbConnection.unlocked Nop
        (\x -> if x then ValidPassword else InvalidPassword)
    ]

view : Model -> Html Msg
view model =
  form [ onSubmit SubmitPassword ]
    [ input
        [ type' "password"
        , classList 
            [ ("invalid", model.recentValidity == Invalid)
            ]
        , autofocus True
        , value model.password
        , onInput PasswordValue
        ] []
    , button [ type' "submit" ] [ text "Unlock" ]
    ]
