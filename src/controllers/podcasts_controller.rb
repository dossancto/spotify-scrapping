# frozen_string_literal: true

require 'sinatra'
require 'json'
require_relative '../services/spotify_navigator'
require_relative '../services/caches/cache_show_cards'

# require_relative '../services/caches/cache_show_cards'

# PodcastsController
class PodcastsController < Sinatra::Base
  get '/show/:id' do
    show_id = params[:id]
    count = params[:count].to_i
    count ||= 5

    return CacheShowCards.read_cards_from_cache(count).to_json if CacheShowCards.valid_cache? && CacheShowCards.enouth_count?(count)

    spotify = SpotifyNavigator.new
    cards = spotify.get_last_videos(show_id, count)
    CacheShowCards.write_cache(cards)

    content_type = 'application/json'

    cards.to_json
  end
end
