module UnitConverter exposing (main)

import Browser
import Html exposing (Html, div, input, span, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { celsiusToFarenheitInput : String
    , farenheitToCelsiusInput : String
    }


init : Model
init =
    { celsiusToFarenheitInput = ""
    , farenheitToCelsiusInput = ""
    }



-- UPDATE


type Msg
    = CelsiusToFarenheit String
    | FarenheitToCelsius String


update : Msg -> Model -> Model
update msg model =
    case msg of
        CelsiusToFarenheit input ->
            { model | celsiusToFarenheitInput = input }

        FarenheitToCelsius input ->
            { model | farenheitToCelsiusInput = input }



-- VIEW


celsiusToFarenheit : Float -> Float
celsiusToFarenheit celsius =
    celsius * 1.8 + 32


farenheitToCelsius : Float -> Float
farenheitToCelsius farenheit =
    (farenheit - 32) / 1.8


view : Model -> Html Msg
view model =
    div []
        [ viewConverter model.celsiusToFarenheitInput CelsiusToFarenheit celsiusToFarenheit "ºC" "ºF"
        , viewConverter model.farenheitToCelsiusInput FarenheitToCelsius farenheitToCelsius "ºF" "ºC"
        ]


viewConverter : String -> (String -> msg) -> (Float -> Float) -> String -> String -> Html msg
viewConverter userInput msg converterFn fromUnit toUnit =
    case String.toFloat userInput of
        Just value ->
            viewConverter_ userInput msg "green" (String.fromFloat (converterFn value)) fromUnit toUnit

        Nothing ->
            viewConverter_ userInput msg "red" "???" fromUnit toUnit


viewConverter_ : String -> (String -> msg) -> String -> String -> String -> String -> Html msg
viewConverter_ userInput msg color equivalentTemp fromUnit toUnit =
    div []
        [ input [ value userInput, onInput msg, style "width" "40px", style "border-color" color ] []
        , text (fromUnit ++ " = ")
        , span [ style "color" color ] [ text equivalentTemp ]
        , text toUnit
        ]
