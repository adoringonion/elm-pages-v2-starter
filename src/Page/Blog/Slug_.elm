module Page.Blog.Slug_ exposing (..)

import Article exposing (..)
import Css exposing (static)
import DataSource
import Date exposing (..)
import Head
import Head.Seo as Seo
import Html exposing (Html, div, h1, p, text)
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


viewPost : Entry -> Html Msg
viewPost entry =
    div []
        [ h1 [] [ text entry.title ]
        , p [] [ text entry.body ]
        ]