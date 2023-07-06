# frozen_string_literal: true

require 'sinatra'
require 'json'
require_relative '../services/spotify_navigator'
require_relative '../services/caches/cache_show_cards'

# PodcastsController
class PodcastsController < Sinatra::Base
  get '/show/:id' do
    show_id = params[:id]
    count = params[:count].to_i

    count = 5 if count.zero?

    cache_controll = CacheShowCards.new(show_id)

    if cache_controll.valid_cache? && cache_controll.enouth_count?(count)
      return cache_controll.read_cards_from_cache(count).to_json
    end

    spotify = SpotifyNavigator.new
    cards = spotify.get_last_videos(show_id, count)

    cache_controll.write_cache(cards)

    content_type = 'application/json'

    cards.to_json
  end

  get '/show/reset_cache/:id' do
    show_id = params[:id]
    cache_controll = CacheShowCards.new(show_id)
    cache_controll.reset_cache
  end
end
