module Page.Index exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import View exposing (View)
import Article exposing (..)
import Html exposing (div)
import Html.Attributes exposing (class)
import Html exposing (Html)
import Date exposing (..)
import Css exposing (static)


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
data = Article.allPosts



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
    , body = List.map viewArticle static.data }


viewArticle : Article.Entry -> Html msg
viewArticle entry =
   div [ class "entry" ] 
   [ div [ class "entry-title" ] [
           Html.text entry.title
    ]
    , div [ class "entry-content" ] [
           Html.text entry.body
    ]
    , div [ class "entry-meta" ] [
           
               publishedDateView entry
    ]
           
    
    , div [ class "entry-tags" ] 
            (viewTags entry.tags)
   ]


viewTags : List Tag -> List (Html msg)
viewTags tags =
    List.map (\tag ->
        div [ class "tag" ] [
            Html.text tag.name
        ]
    ) tags

publishedDateView : { a | published : Date } -> Html msg
publishedDateView metadata =
    Html.text (Date.format "yyy-MM-dd" metadata.published)