module EntryList
    exposing
        ( Model
        , Msg(UpdateFilter)
        , Filter
        , init
        , update
        , subscriptions
        , view
        , hostnameFilter
        )

import Html exposing (text)
import Dict
import KdbConnection exposing (Entry)


type alias Filter =
    Entry -> Bool


type Msg
    = Nop
    | UpdateFilter Filter
    | RenewEntries
    | ReadEntries (List Entry)
    | FillEntry String
    | FillFailure
    | FillSuccess


type alias Model =
    { filter : Filter
    , entries : List Entry
    , filteredEntries : List Entry
    }


init : Filter -> ( Model, Cmd Msg )
init f =
    (Model f [] []) ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Nop ->
            model ! []

        UpdateFilter f ->
            { model
                | filter = f
                , filteredEntries = List.filter f model.entries
            }
                ! []

        RenewEntries ->
            model ! [ KdbConnection.readEntries ]

        ReadEntries e ->
            { model
                | entries = e
                , filteredEntries = List.filter model.filter e
            }
                ! []

        FillEntry s ->
            model ! [ KdbConnection.fill s ]

        FillSuccess ->
            model ! []

        FillFailure ->
            model ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ KdbConnection.entries Nop ReadEntries
        , KdbConnection.filled Nop
            (\x ->
                if x then
                    FillSuccess
                else
                    FillFailure
            )
        ]


view : Model -> Html.Html Msg
view model =
    text "This is an Entry List"


hostnameFilter : String -> Filter
hostnameFilter hostname e =
    case Dict.get "URL" e.fields of
        Nothing ->
            False

        Just url ->
            String.contains hostname url || String.contains url hostname
