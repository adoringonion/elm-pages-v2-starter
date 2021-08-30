module Shared exposing (Data, Model, Msg(..), SharedMsg(..), template)

import Browser.Navigation
import DataSource
import Date exposing (Date)
import Element exposing (Element, column, layout, link, row, spaceEvenly, text)
import Element.Background exposing (..)
import Element.Font as Font exposing (Font)
import Element.Region exposing (navigation)
import Html exposing (Html)
import Pages.Flags exposing (Flags)
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
import View exposing (View)


template : SharedTemplate Msg Model Data msg
template =
    { init = init
    , update = update
    , view = view
    , data = data
    , subscriptions = subscriptions
    , onPageChange = Just OnPageChange
    }


type Msg
    = OnPageChange
        { path : Path
        , query : Maybe String
        , fragment : Maybe String
        }
    | SharedMsg SharedMsg


type alias Data =
    ()


type SharedMsg
    = NoOp


type alias Model =
    { showMobileMenu : Bool
    }


init :
    Maybe Browser.Navigation.Key
    -> Pages.Flags.Flags
    ->
        Maybe
            { path :
                { path : Path
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : route
            , pageUrl : Maybe PageUrl
            }
    -> ( Model, Cmd Msg )
init _ _ _ =
    ( { showMobileMenu = False }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange _ ->
            ( { model | showMobileMenu = False }, Cmd.none )

        SharedMsg _ ->
            ( model, Cmd.none )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none


data : DataSource.DataSource Data
data =
    DataSource.succeed ()


view :
    Data
    ->
        { path : Path
        , route : Maybe Route
        }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : Html msg, title : String }
view _ _ _ _ pageView =
    { body =
        layout
            [ Element.width (Element.fill |> Element.minimum 400)
            , Element.height Element.fill
            , Element.explain Debug.todo
            ]
            (column
                [ Element.width Element.fill
                ]
                [ header
                , bodyWrapper pageView.body
                ]
            )
    , title = pageView.title
    }


bodyWrapper : List (Element msg) -> Element msg
bodyWrapper body =
    Element.column
        [ Element.width Element.fill
        , Element.paddingEach { top = 40, bottom = 40, left = 100, right = 100 }
        , Element.explain Debug.todo
        ]
        body


header : Element msg
header =
    Element.row
        [ Element.width (Element.fill |> Element.minimum 400)
        , Element.height (Element.px 60)
        , Element.spaceEvenly
        , Element.padding 10
        , Element.Background.color (Element.rgb 0 0.5 0)
        , Element.explain Debug.todo
        ]
        [ Element.el
            [ Font.bold
            , Font.size 30
            ]
            (link [] { url = "/?tagName=eeeee", label = text "Blog" })
        , menu
        ]


menu : Element msg
menu =
    row
        [ navigation
        , Element.spacing 40
        ]
        [ link [] { url = "/", label = text "Posts" }
        , link [] { url = "/about", label = text "About" }
        ]


publishedDateView : { a | published : Date } -> Element msg
publishedDateView metadata =
    Element.el
        []
        (text (Date.format "yyy-MM-dd" metadata.published))
