module Page.Blog.Slug_ exposing (..)

import Article exposing (..)
import Css exposing (static)
import DataSource
import Date exposing (..)
import Head
import Head.Seo as Seo
import Html.Parser as Parser
import Html.Parser.Util as ParserUtil
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared exposing (Msg)
import View exposing (View)
import Element exposing (..)
import Element.Region as Region


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
    column []
        [ el [ Region.heading 1] (text entry.title)
        , column [] (textHtml entry.body)
        ]


textHtml : String -> List (Element msg)
textHtml t =
    case Parser.run t of
        Ok nodes ->
            List.map html (ParserUtil.toVirtualDom nodes)

        Err _ ->
            []
