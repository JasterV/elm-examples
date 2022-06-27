module WeatherApp exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Env exposing (apiKey, apiUrl)
import Html exposing (Html, button, div, input, pre, span, text)
import Html.Attributes exposing (placeholder, style, value)
import Html.Events exposing (onClick, onInput)
import Http



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : () -> ( Model, Cmd Msg )
init flags =
    ( initialModel flags
    , Cmd.none
    )



-- MODEL


type alias WeatherInfo =
    String


type State
    = Initial
    | Loading
    | Success WeatherInfo
    | Failure


type alias Model =
    { input : String
    , state : State
    }


initialModel : () -> Model
initialModel _ =
    Model "" Initial



-- UPDATE


type Msg
    = GotWeather (Result Http.Error String)
    | ChangeLocation String
    | RequestWeatherInfo


updateWeather : Result Http.Error String -> Model -> ( Model, Cmd Msg )
updateWeather result model =
    case result of
        Ok weather ->
            ( { model | state = Success weather }, Cmd.none )

        Err _ ->
            ( { model | state = Failure }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotWeather result ->
            updateWeather result model

        ChangeLocation input ->
            ( { model | input = input }, Cmd.none )

        RequestWeatherInfo ->
            ( { model | state = Loading }, getWeather model.input )



-- HTTP


getWeather : String -> Cmd Msg
getWeather location =
    Http.get
        { url = apiUrl ++ "?key=" ++ apiKey ++ "&q=" ++ location
        , expect = Http.expectString GotWeather
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ viewInput model
        , button [ style "display" "block", onClick RequestWeatherInfo ] [ text "Get Weather!" ]
        , span [] [ viewWeather model ]
        ]


viewWeather : Model -> Html Msg
viewWeather model =
    case model.state of
        Failure ->
            text "There was an error fetching the weather"

        Loading ->
            text "Loading..."

        Initial ->
            text "Welcome! Submit a location to fetch weather info"

        Success weatherInfo ->
            pre [] [ text weatherInfo ]


viewInput : Model -> Html Msg
viewInput model =
    input [ placeholder "Barcelona, Spain", onInput ChangeLocation, value model.input ] []
