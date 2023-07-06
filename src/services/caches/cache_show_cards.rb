# frozen_string_literal: true

require 'json'
require_relative '../../models/spotify_card_cache_model'

CACHE_DIRECTORY = File.join(Dir.home, '.cache/spotify_scrap')
CACHE_FILE_LOCATION = File.join(CACHE_DIRECTORY, 'cards.json')

MAX_ALIVE = 60 * 60 * 1000 # 1 Hour

## CacheShowCards
module CacheShowCards
  def self.setup_config_file
    Dir.mkdir(CACHE_DIRECTORY) unless Dir.exist?(CACHE_DIRECTORY)
  end

  def self.read_cache
    File.read(CACHE_FILE_LOCATION)
  end

  def self.read_cards_from_cache(count)
    return unless enouth_count?(count)

    cache = JSON.parse(read_cache)
    cards = SpotifyCardCacheModel.from_hash(cache).cards

    cards[0...count]
  end

  def self.currency_from_cache
    JSON.parse(read_cache)
  end

  def self.valid_cache?
    return false unless File.exist? CACHE_FILE_LOCATION
    return false unless Dir.exist? CACHE_DIRECTORY

    cache_yet_valid?
  end

  def self.enouth_count?(count)
    cache = JSON.parse(read_cache)

    cached_count = cache['count']
    cached_count >= count
  end

  def self.cache_yet_valid?
    cache = JSON.parse(read_cache)

    given_timestamp = cache['timestamp']

    current_timestamp = Time.now.to_i
    time_difference = current_timestamp - given_timestamp

    time_difference < MAX_ALIVE
  end

  def self.write_cache(cards)
    setup_config_file

    cache = SpotifyCardCacheModel.new(cards)

    File.open(CACHE_FILE_LOCATION, 'w') do |file|
      content = cache.to_json
      file.puts content
      puts 'Cards saved.'
    end
  end
end
