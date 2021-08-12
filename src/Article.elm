module Article exposing (allPosts, Entry, Tag)
import DataSource
import DataSource.Http
import Date exposing (Date)
import Pages.Secrets as Secrets
import OptimizedDecoder as Decode

type alias Entry =
    { id : String
    , title : String
    , body : String
    , published : Date
    , tags : List Tag
    }

type alias Tag = { name : String }

allPosts : DataSource.DataSource (List Entry)
allPosts =
    DataSource.Http.request
        (Secrets.succeed
            (\apiKey ->
                { url = "https://adoringonion.microcms.io/api/v1/blog"
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
    Decode.map5 Entry
        (Decode.field "id" Decode.string)
        (Decode.field "title" Decode.string)
        (Decode.field "body" Decode.string)
        (Decode.field "updatedAt"
            (Decode.string
                |> Decode.andThen
                    (\isoString ->
                        String.slice 0 10 isoString
                            |> Date.fromIsoString 
                            |> Decode.fromResult
                    )
            )
        )
        (Decode.field "tags" <| Decode.list tagDecoder)


tagDecoder : Decode.Decoder Tag
tagDecoder =
    Decode.map Tag (Decode.field "name" Decode.string)