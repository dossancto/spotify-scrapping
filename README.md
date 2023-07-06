# spotify-scrapping
To check the last podcasts from a user

## Install

- Clone the repo 

```sh
bundle install # Install dependencies
```

## Running

```sh
ruby src/sever.rb # Start server
```

Go to localhost:4567

## Usage

```
curl localhost:4567/show/{show-id}?count={count}
```

- if `count` is not used, the default value is used (5).
- `count` is the number of episodes to be displayed.

## About

- All request are cached in `$HOME/.cache/spotify_scrap/cards-{show-id}.json`. And will be used in future requests

- The live time for the cache is 1 hour, after this the cache is considered invalid, and the scrapping runs again. 

- If the requested `count` is gratter than the cached, a new scrapping will run to get the max count. Otherwise cache is used.

Projeto para fins de brincar com Scrapping
