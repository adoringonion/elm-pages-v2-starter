module Page.Blog.Post.Slug_ exposing (..)

import Article exposing (..)
import Css exposing (static)
import DataSource
import Date exposing (..)
import Element exposing (..)
import Element.Background as Background exposing (..)
import Element.Font as Font exposing (Font)
import Element.Region as Region
import Head
import Head.Seo as Seo
import Html.Parser as Parser
import Html.Parser.Util as ParserUtil
import Markdown
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Route
import Shared exposing (Msg)
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { slug : String }


page : Page RouteParams Data
page =
    Page.prerender
        { head = head
        , data = data
        , routes = routes
        }
        |> Page.buildNoState { view = view }


routes : DataSource.DataSource (List RouteParams)
routes =
    Article.allPosts
        |> DataSource.map
            (List.map
                (\post ->
                    { slug = post.id }
                )
            )


data : RouteParams -> DataSource.DataSource Data
data route =
    Article.allPosts
        |> DataSource.map
            (\allPost ->
                List.filter
                    (\post -> post.id == route.slug)
                    allPost
                    |> List.head
            )
        |> DataSource.andThen
            (\maybepost ->
                case maybepost of
                    Just post ->
                        DataSource.succeed post

                    Nothing ->
                        DataSource.fail (route.slug ++ " is not found")
            )


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = static.data.title ++ " | TestBlog"
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
    Entry


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view _ _ static =
    { title = static.data.title ++ " | TestBlog"
    , body = [ viewPost static.data ]
    }


viewPost : Entry -> Element Msg
viewPost entry =
    column
        [ Element.width Element.fill
        , Element.explain Debug.todo
        , Element.paddingXY 0 50
        ]
        [ viewTitle entry.title
        , publishedDateView entry.published
        , viewTags entry.tags
        , column
            [ Element.width (Element.fill |> Element.maximum 1000)
            , Element.centerX
            , Element.paddingXY 30 0
            ]
            [ postBody entry.body ]
        ]


postBody : String -> Element Msg
postBody body =
    Element.paragraph
        [ Element.explain Debug.todo
        , Element.width Element.fill
        , Background.color (rgba 20 0 0 0.4)
        ]
        [ Element.html
            (Markdown.toHtml [] body)
        ]


viewTitle : String -> Element Msg
viewTitle title =
    Element.paragraph [ Element.centerX, Font.center, Font.size 40, Font.bold, Element.width (Element.fill |> Element.maximum 1000) ]
        [ Element.text title
        ]


publishedDateView : Date -> Element msg
publishedDateView date =
    Element.row
        [ Font.size 20
        ]
        [ text (Date.format "yyy-MM-dd" date) ]


viewTags : List Tag -> Element msg
viewTags tags =
    Element.row
        [ Element.padding 3
        ]
        (List.map
            (\tag ->
                Element.link
                    [ Element.padding 3
                    , Background.color (Element.rgb 20 0 0)
                    ]
                    { url = "/blog/category/" ++ tag.id, label = text tag.name }
            )
            tags
        )
