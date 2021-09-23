module Page.About exposing (Data, Model, Msg, page)

import Article exposing (..)
import DataSource exposing (DataSource)
import Date exposing (..)
import Element exposing (..)
import Head
import Head.Seo as Seo
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Path
import Shared
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
    { title = "About"
    , body = [ content ]
    }


content : Element Msg
content =
    Element.column
        [ Element.paddingXY 20 10
        , Element.explain Debug.todo
        , Element.padding 50
        , Element.width Element.fill
        ]
        [ introduction
        , carreer
        , links
        ]


introduction : Element Msg
introduction =
    Element.row
        [ Element.explain Debug.todo
        , Element.width Element.fill
        ]
        [ Element.textColumn []
            [ Element.text "John Do"
            , Element.text "名前 森田文人"
            ]
        , Element.image [
            Element.width (Element.fill |> Element.maximum 300)
        ]
            { src = "images/profile.jpg", description = "John Do" }
        ]


carreer : Element Msg
carreer =
    Element.column
        [ Element.width Element.fill
        ]
        []


links : Element Msg
links =
    Element.column
        [ Element.width Element.fill
        ]
        []
