SPOTIFY_BASE_URL = 'https://open.spotify.com'
class SpotifyCardModel
  attr_reader :title, :description, :duration, :date, :video_id

  def initialize(title, description, duration, date, video_id)
    @title = title
    @description = description
    @duration = duration
    @date = date
    @video_id = video_id
  end

  def to_s
    "Card {title: #{@title}, description: #{@description}, duration: #{duration}, date: #{date}, video_id: #{video_id}}"
  end

  def url_to_video
    "#{SPOTIFY_BASE_URL}/episode/#{@video_id}"
  end
end
