# frozen_string_literal: true

require 'json'
require_relative './spotify_card_model'

## SpotifyCardCacheModel
class SpotifyCardCacheModel
  attr_reader :timestamp, :cards, :count

  def initialize(cards)
    @cards = cards
    @timestamp = Time.now
    @count = cards.length
  end

  def as_json(_options = {})
    {
      cards: @cards,
      count: @count,
      timestamp: @timestamp.to_i
    }
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end

  def self.from_hash(hash)
    cards = hash['cards'].map do |card|
      SpotifyCardModel.from_hash(card)
    end

    SpotifyCardCacheModel.new(cards)
  end
end
