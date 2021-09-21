module Page.Blog.Category.Tag_ exposing (..)

import Article exposing (..)
import Css exposing (static)
import DataSource
import Date exposing (..)
import Element exposing (..)
import Element.Background exposing (..)
import Element.Border
import Element.Font
import Head
import Head.Seo as Seo
import List.Extra exposing (unique)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared exposing (Msg)
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { tag : String }


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
        |> DataSource.map (List.map (\post -> post.tags))
        |> DataSource.map List.concat
        |> DataSource.map (List.map (\tag -> tag.id))
        |> DataSource.map unique
        |> DataSource.map (List.map (\id -> { tag = id }))


data : RouteParams -> DataSource.DataSource Data
data route =
    Article.allPosts
        |> DataSource.map
            (\allPost ->
                List.filter
                    (\post ->
                        List.member route.tag
                            (List.map
                                (\tag -> tag.id)
                                post.tags
                            )
                    )
                    allPost
            )


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = static.routeParams.tag ++ " | Blog"
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
    { title = static.routeParams.tag ++ " | Blog"
    , body = [wrapper static.data]
    }


wrapper : List Entry -> Element Msg
wrapper entries =
    Element.row
        [ Element.paddingXY 50 70
        , Element.width Element.fill
        ]
        [ articleColumn entries ]


articleColumn : List Entry -> Element Msg
articleColumn entries =
    Element.column
        [ centerX, Element.width (Element.fill |> Element.maximum 800 |> Element.minimum 300), Element.spacing 20 ]
        (List.map viewArticle entries)


viewArticle : Article.Entry -> Element msg
viewArticle entry =
    Element.link
        [ Element.Background.color (Element.rgb 200 0 0)
        , Element.padding 10
        , Element.Border.rounded 5
        , Element.width Element.fill
        , Element.height <| Element.px 150
        ]
        { url = "/blog/post/" ++ entry.id
        , label =
            Element.row
                []
                [ Element.textColumn
                    [ Element.padding 20, Element.spacing 10 ]
                    [ Element.paragraph
                        [ Element.Font.size 23
                        , Element.Font.semiBold
                        ]
                        [ text entry.title ]
                    , publishedDateView entry
                    , viewTags entry.tags
                    ]
                ]
        }


viewTags : List Tag -> Element msg
viewTags tags =
    let
        pickOutTags =
            List.take 5 tags
    in
    Element.row
        []
        (List.map
            (\tag ->
                el
                    [ Element.Border.solid
                    , Element.Border.width 1
                    , Element.Border.rounded 10
                    , Element.padding 5
                    ]
                    (text tag.name)
            )
            pickOutTags
        )


publishedDateView : { a | published : Date } -> Element msg
publishedDateView metadata =
    Element.el
        [ Element.Font.size 16 ]
        (text (Date.format "yyy-MM-dd" metadata.published))
