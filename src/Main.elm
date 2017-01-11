module Main exposing (..)

import Html exposing (Html, div, text)
import KdbConnection exposing (Entry)
import Unlocker
import EntryList


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    { unlocked : Bool
    , unlocker : Unlocker.Model
    , entries : EntryList.Model
    , hostname : String
    }


type alias Flags =
    { hostname : String
    }


init : Flags -> ( Model, Cmd Msg )
init { hostname } =
    let
        ( unlocker, ucmd ) =
            Unlocker.init

        ( entries, ecmd ) =
            EntryList.init
    in
        (Model False unlocker entries hostname)
            ! [ Cmd.map UnlockerMsg ucmd
              , Cmd.map EntryListMsg ecmd
              ]


type Msg
    = Nop
    | DatabaseUnlocked
    | DatabaseLocked
    | UnlockerMsg Unlocker.Msg
    | EntryListMsg EntryList.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
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
                ( newUnlocker, cmd ) =
                    Unlocker.update msg model.unlocker
            in
                { model | unlocker = newUnlocker } ! [ Cmd.map UnlockerMsg cmd ]

        EntryListMsg msg ->
            let
                ( newEntries, cmd ) =
                    EntryList.update msg model.entries
            in
                { model | entries = newEntries } ! [ Cmd.map EntryListMsg cmd ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ KdbConnection.unlocked Nop
            (\x ->
                if x then
                    DatabaseUnlocked
                else
                    DatabaseLocked
            )
        ]


view : Model -> Html Msg
view model =
    if not model.unlocked then
        Unlocker.view model.unlocker
            |> Html.map UnlockerMsg
    else
        EntryList.view model.entries
            |> Html.map EntryListMsg
