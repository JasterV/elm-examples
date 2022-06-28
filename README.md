# Elm examples

This is my first project with Elm. Here I've added the basic examples built following the Elm guide.

I've also added some extra logic on each example to play with Elm a little bit and get more familiar with it.

## Run

```bash
elm reactor
```

## Weather App example

I would say the most complete example for now it's the weather one.

It involves cool stuff like env variables & http commands and I want to add some JSON manipulation (right now it just gets the weather response as a string).

### Setup

Copy the `Env.example.elm` to `src/Env.elm` and add the required variables:

* Api base URL: I'm using a free [weather API](https://www.weatherapi.com/), sign up & get the API credentials.
* API key: Once you have your account, copy the API key you will find on your dashboard.

## Resources

* [Install Elm](https://guide.elm-lang.org/install/elm.html)
* [Elm guide](https://guide.elm-lang.org/)
