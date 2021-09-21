module Page.Index exposing (..)

import Article exposing (..)
import Browser.Navigation exposing (Key)
import Css exposing (static)
import DataSource exposing (DataSource)
import Date exposing (..)
import Element exposing (..)
import Element.Background
import Element.Border
import Element.Input exposing (button)
import Element.Region exposing (description)
import Head
import Head.Seo as Seo
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Path exposing (Path)
import Shared
import String exposing (left)
import View exposing (View)
import Element.Font


type alias Model =
    Int


type Msg
    = NextPage


type alias RouteParams =
    {}


init : Maybe PageUrl -> Shared.Model -> StaticPayload Data RouteParams -> ( Model, Cmd Msg )
init _ _ _ =
    ( 1, Cmd.none )


subscriptions :
    Maybe PageUrl
    -> RouteParams
    -> Path
    -> Model
    -> Sub Msg
subscriptions _ _ _ _ =
    Sub.none


update :
    PageUrl
    -> Maybe Browser.Navigation.Key
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> Msg
    -> Model
    -> ( Model, Cmd Msg )
update _ _ _ _ msg model =
    case msg of
        NextPage ->
            ( model + 1, Cmd.none )


page : PageWithState RouteParams Data Model Msg
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildWithLocalState
            { init = init
            , view = view
            , subscriptions = subscriptions
            , update = update
            }


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
    -> Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel model static =
    { title = "MyBlog"
    , body = [ wrapper static.data model ]
    }


wrapper : List Entry -> Model -> Element Msg
wrapper entries model =
    Element.row
        [ Element.paddingXY 50 70
        , Element.width Element.fill
        ]
        [ articleColumn entries model ]


articleColumn : List Entry -> Model -> Element Msg
articleColumn entries model =
    Element.column
        [ centerX, Element.width (Element.fill |> Element.maximum 800 |> Element.minimum 300), Element.spacing 20 ]
        (List.map viewArticle (List.take model entries) ++ [ nextButton entries model ])


nextButton : List Entry -> Model -> Element Msg
nextButton entries model =
    if model >= List.length entries then
        Element.none
    else
        Element.row [ Element.explain Debug.todo, Element.width Element.fill ]
            [ button [ Element.padding 10, Element.centerX ]
                { onPress = Just NextPage, label = text "More" }
            ]


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
                    [ Element.padding 20, Element.spacing 10]
                    [ Element.paragraph [
                        Element.Font.size 23
                        , Element.Font.semiBold
                    ] [ text entry.title ]
                    , publishedDateView entry
                    , viewTags entry.tags
                    ]
                ]
        }


viewTags : List Tag -> Element msg
viewTags tags =
    let
        pickOutTags = List.take 5 tags
    in
    
    Element.row
        []
        (List.map
            (\tag ->
                el [
                    Element.Border.solid
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
        [Element.Font.size 16]
        (text (Date.format "yyy-MM-dd" metadata.published))
