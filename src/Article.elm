module Article exposing (..)
import DataSource
import DataSource.Http
import Pages.Secrets as Secrets
import OptimizedDecoder as Decode
import Json.Decode.Pipeline exposing (required, optional, hardcoded)

type alias Entry =
    { title : String
    , body : String
    , tags : List Tag
    }

type alias Tag = { name : String }

staticRequest : DataSource.DataSource (List Entry)
staticRequest =
    DataSource.Http.request
        (Secrets.succeed
            (\apiKey ->
                { url = "https://api.airtable.com/v0/appDykQzbkQJAidjt/elm-pages%20showcase?maxRecords=100&view=Grid%202"
                , method = "GET"
                , headers = [ ( "X-API-KEY", apiKey ) ]
                , body = DataSource.Http.emptyBody
                }
            )
            |> Secrets.with "API_KEY"
        )
        decoder

decoder : Decode.Decoder (List Entry)
decoder =
    Decode.field "contents" <|
        Decode.list entryDecoder

entryDecoder : Decode.Decoder Entry
entryDecoder =
        Decode.map3 Entry
            (Decode.field "title" Decode.string)
            (Decode.field "body" Decode.string)
            (Decode.field "tags" <| Decode.list tagDecoder)


tagDecoder : Decode.Decoder Tag
tagDecoder =
    Decode.map Tag (Decode.field "name" Decode.string)