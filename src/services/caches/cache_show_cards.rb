# frozen_string_literal: true

require 'json'
require_relative '../../models/spotify_card_cache_model'

CACHE_DIRECTORY = File.join(Dir.home, '.cache/spotify_scrap')
CACHE_FILE_LOCATION = File.join(CACHE_DIRECTORY, 'cards-{show-id}.json')

MAX_ALIVE = 60 * 60 * 1000 # 1 Hour

## CacheShowCards
class CacheShowCards
  attr_reader :show_id, :count

  def initialize(show_id)
    @show_id = show_id
    @file_location = CACHE_FILE_LOCATION.gsub('{show-id}', show_id)
  end

  def setup_config_file
    Dir.mkdir(CACHE_DIRECTORY) unless Dir.exist?(CACHE_DIRECTORY)
  end

  def read_cache
    File.read(@file_location)
  end

  def read_cards_from_cache(count)
    return unless enouth_count?(count)

    cache = JSON.parse(read_cache)
    cards = SpotifyCardCacheModel.from_hash(cache).cards

    cards[0...count]
  end

  def currency_from_cache
    JSON.parse(read_cache)
  end

  def valid_cache?
    return false unless File.exist? @file_location
    return false unless Dir.exist? CACHE_DIRECTORY

    cache_yet_valid?
  end

  def enouth_count?(count)
    cache = JSON.parse(read_cache)

    cached_count = cache['count']
    cached_count >= count
  end

  def cache_yet_valid?
    cache = JSON.parse(read_cache)

    given_timestamp = cache['timestamp']

    current_timestamp = Time.now.to_i
    time_difference = current_timestamp - given_timestamp

    time_difference < MAX_ALIVE
  end

  def write_cache(cards)
    setup_config_file

    cache = SpotifyCardCacheModel.new(cards)

    File.open(@file_location, 'w') do |file|
      content = cache.to_json
      file.puts content
      puts 'Cards saved.'
    end
  end

  def reset_cache
    File.delete(@file_location)
    'Cache reseted'
  rescue Errno::ENOENT
    'Error while resetting cache'
  end
end
