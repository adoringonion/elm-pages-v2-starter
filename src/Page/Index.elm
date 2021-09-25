module Page.Index exposing (..)

import Article exposing (..)
import Browser.Navigation exposing (Key)
import Css exposing (static)
import DataSource exposing (DataSource)
import Date exposing (..)
import Element exposing (..)
import Element.Background
import Element.Border
import Element.Font
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


type alias Model =
    Int


type Msg
    = MorePosts


type alias RouteParams =
    {}


init : Maybe PageUrl -> Shared.Model -> StaticPayload Data RouteParams -> ( Model, Cmd Msg )
init _ _ _ =
    ( 10, Cmd.none )


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
        MorePosts ->
            ( model + 10, Cmd.none )


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
        , siteName = ""
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "MyBlog" -- metadata.title -- TODO
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
    , body = [ articleColumn static.data model ]
    }


articleColumn : List Entry -> Model -> Element Msg
articleColumn entries model =
    Element.row
        [ Element.paddingXY 50 70
        , Element.width Element.fill
        ]
        [ Element.column
            [ centerX, Element.width (Element.fill |> Element.maximum 600), Element.spacing 20 ]
            (List.map articleCard (List.take model entries) ++ [ morePostsButton entries model ])
        ]


morePostsButton : List Entry -> Model -> Element Msg
morePostsButton entries model =
    if model >= List.length entries then
        Element.none

    else
        Element.row [ Element.width Element.fill ]
            [ button [ Element.padding 10, Element.centerX, Element.Font.semiBold, Element.Font.size 30 ]
                { onPress = Just MorePosts, label = text "More" }
            ]


articleCard : Article.Entry -> Element msg
articleCard entry =
    Element.link
        [ Element.padding 10
        , Element.Border.rounded 5
        , Element.width Element.fill
        , Element.Border.color (Element.rgba 0 0 0 0.2)
        , Element.Border.solid
        , Element.Border.width 1
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
                        [ text entry.title]
                    , publishedDateView entry
                    , viewTags entry.tags
                    ]
                ]
        }


viewTags : List Tag -> Element msg
viewTags tags =
    Element.row
        [ Element.spacing 10
        ]
        (List.map
            (\tag ->
                el
                    [ 
                    Element.padding 7
                    , Element.Font.center
                    ]
                    (text ( "#" ++ tag.name))
            )
            (List.take 5 tags)
        )


publishedDateView : { a | published : Date } -> Element msg
publishedDateView metadata =
    Element.paragraph
        [ Element.Font.size 16 ]
        [ text (Date.format "yyy-MM-dd" metadata.published) ]
