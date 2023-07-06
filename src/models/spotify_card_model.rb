# frozen_string_literal: true

SPOTIFY_BASE_URL = 'https://open.spotify.com'

## SpotifyCardModel
class SpotifyCardModel
  attr_accessor :title, :description, :duration, :date, :video_id

  def initialize(title, description, duration, date, video_id)
    @title = title
    @description = description
    @duration = duration
    @date = date
    @video_id = video_id
  end

  def as_json(_options = {})
    {
      id: @video_id,
      title: @title,
      description: @description,
      date: @date,
      duration: @duration,
      url: url_to_video
    }
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end

  def to_s
    "Card {title: #{@title}, description: #{@description}, duration: #{duration}, date: #{date}, video_id: #{video_id}}"
  end

  def url_to_video
    "#{SPOTIFY_BASE_URL}/episode/#{@video_id}"
  end

  def self.from_hash(hash)
    SpotifyCardModel.new(hash['title'], hash['description'], hash['duration'], hash['date'], hash['id'])
  end
end
