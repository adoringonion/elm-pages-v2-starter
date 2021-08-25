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
import Date exposing (..)
import Element exposing (..)


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


viewArticle : Article.Entry -> Element msg
viewArticle entry =
   column [  ] 
   [ el [ ] 
           (text entry.title)
    
    , el [ ] 
           (text entry.body)
    
    , el [ ] 
           
               (publishedDateView entry)
    
           
    
    , row [ ] 
            (viewTags entry.tags)
   ]


viewTags : List Tag -> List (Element msg)
viewTags tags =
    List.map (\tag ->
        el [  ] 
            (text tag.name)
        
    ) tags

publishedDateView : { a | published : Date } -> Element msg
publishedDateView metadata =
    text (Date.format "yyy-MM-dd" metadata.published)