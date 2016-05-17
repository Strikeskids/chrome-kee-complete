port module KdbConnection exposing
  ( Entry
  , unlock, readEntries, fill
  , unlocked, entries, filled, subscriptions
  )

import Json.Decode as Json exposing ( (:=), bool, string )
import Dict exposing ( Dict )


type alias Entry =
  { uuid : String
  , fields : Dict String String
  }

unlock : String -> Cmd msg
unlock passwd =
  kdbxRequest { baseRequest | unlock = Just passwd }

readEntries : Cmd msg
readEntries =
  kdbxRequest { baseRequest | read = True }

fill : String -> Cmd msg
fill entryUuid =
  kdbxRequest { baseRequest | fill = Just entryUuid }

unlocked = subscription unlockedSign
entries = subscription entrySign
filled = subscription filledSign

subscription : Json.Decoder t -> msg -> (t -> msg) -> Sub msg
subscription decoder invalid f =
  kdbxResponse
    (Json.decodeValue (Json.map f decoder)
      >> Result.withDefault invalid)

subscriptions : msg -> (Bool -> msg) -> (List Entry -> msg) -> (Bool -> msg) -> Sub msg
subscriptions invalid unlocked entries filled =
  kdbxResponse
    (Json.decodeValue (signs unlocked entries filled)
      >> Result.withDefault invalid)


port kdbxRequest : KdbxRequest -> Cmd msg
port kdbxResponse : (Json.Value -> msg) -> Sub msg

type alias KdbxRequest =
  { unlock : Maybe String
  , read : Bool
  , fill : Maybe String
  }

baseRequest =
  KdbxRequest Nothing False Nothing

entry : Json.Decoder Entry
entry =
  Json.object2 Entry
    (Json.at ["uuid", "id"] Json.string)
    (Json.at ["fields"] (Json.dict Json.string))

entrySign : Json.Decoder (List Entry)
entrySign =
  ("entries" := (Json.list entry))

unlockedSign : Json.Decoder Bool
unlockedSign =
  ("unlocked" := Json.bool)

filledSign : Json.Decoder Bool
filledSign =
  ("filled" := Json.bool)

signs unlocked entries filled =
  Json.oneOf
    [ Json.map unlocked unlockedSign
    , Json.map entries entrySign
    , Json.map filled filledSign
    ]
