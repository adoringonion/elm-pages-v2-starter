module Page.Index exposing (Data, Model, Msg, page, publishedDateView, viewTags, viewArticle)

import Article exposing (..)
import DataSource exposing (DataSource)
import Date exposing (..)
import Element exposing (..)
import Element.Background
import Element.Border
import Element.Region exposing (description)
import Head
import Head.Seo as Seo
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import String exposing (left)
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


data : DataSource Data
data =
    Article.allPosts


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
        |> Seo.website


type alias Data =
    List Entry


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "Index"
    , body = List.map viewArticle static.data
    }


viewArticle : Article.Entry -> Element msg
viewArticle entry =
    Element.link
        [ Element.Background.color (Element.rgb 200 0 0)
        , Element.padding 10
        , Element.explain Debug.todo
        , Element.Border.rounded 5
        ]
        { url = "/blog/" ++ entry.id
        , label =
            Element.row
                []
                [ Element.column []
                    [ Element.text entry.title
                    , publishedDateView entry
                    , viewTags entry.tags
                    ]
                ]
        }


viewTags : List Tag -> Element msg
viewTags tags =
    Element.row
        []
        (List.map
            (\tag ->
                el []
                    (text tag.name)
            )
            tags
        )


publishedDateView : { a | published : Date } -> Element msg
publishedDateView metadata =
    Element.el
        []
        (text (Date.format "yyy-MM-dd" metadata.published))


summaryView : String -> Element msg
summaryView summary =
    if String.length summary > 30 then
        Element.text <| left 30 summary ++ "..."

    else
        Element.text summary
