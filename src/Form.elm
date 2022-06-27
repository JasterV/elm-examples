module Form exposing (Model, Msg(..), init, main, update, view, viewInput, viewValidation)

import Browser
import Char exposing (isDigit, isLower, isUpper)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    }


init : Model
init =
    Model "" "" ""



-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }

        Password password ->
            { model | password = password }

        PasswordAgain password ->
            { model | passwordAgain = password }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ viewInput "text" "Name" model.name Name
        , viewInput "password" "Password" model.password Password
        , viewInput "password" "Re-enter Password" model.passwordAgain PasswordAgain
        , viewValidation model
        ]



-- Helper components


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []



-- Validation components


type PasswordValidation
    = Valid
    | TooShort
    | MissingCharacters
    | NoMatch


containsUpperCase : String -> Bool
containsUpperCase word =
    String.any isUpper word


containsLowerCase : String -> Bool
containsLowerCase word =
    String.any isLower word


containsNumeric : String -> Bool
containsNumeric word =
    String.any isDigit word


validatePassword : String -> String -> PasswordValidation
validatePassword password passwordAgain =
    if password /= passwordAgain then
        NoMatch

    else if String.length password < 8 then
        TooShort

    else if not (containsLowerCase password && containsNumeric password && containsUpperCase password) then
        MissingCharacters

    else
        Valid


msgBox : String -> String -> Html msg
msgBox color msg =
    div [ style "color" color ] [ text msg ]


viewValidation : Model -> Html msg
viewValidation model =
    case validatePassword model.password model.passwordAgain of
        NoMatch ->
            msgBox "red" "Passwords don't match!"

        MissingCharacters ->
            msgBox "red" "Password must contain at least 1 Upper case character, 1 lower case and 1 numeric character"

        TooShort ->
            msgBox "red" "Password too short"

        Valid ->
            msgBox "green" "Ok!"
