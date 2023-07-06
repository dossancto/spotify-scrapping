# frozen_string_literal: true

require 'selenium-webdriver'
require_relative '../models/spotify_card_model'
# require 'models/spotify_card_model'

VIDEOS_LIST_ELEMENT = "document.querySelector('div[data-testid=infinite-scroll-list]')"

## SpotifyNavigator
class SpotifyNavigator
  attr_reader :url, :options, :driver

  def initialize(show_id)
    @url = get_url(show_id)
    @options = Selenium::WebDriver::Chrome::Options.new
    @options.add_argument('--enable-javascript')
    @options.add_argument('headless')
    @driver = Selenium::WebDriver.for(:chrome, options:)
    # @slaves = (1..4).map { Selenium::WebDriver.for(:chrome, options:) }
    @retry_count = 3
  end

  def get_url(show_id)
    "https://open.spotify.com/show/#{show_id}"
  end

  def exist_list?(_url)
    element = @driver.execute_script("return #{VIDEOS_LIST_ELEMENT}")

    return false if element.nil?
    return false if element == false

    true
  end

  def get_last_videos(count = 5)
    begin
      @driver.get(@url)
      get_cards_infos(count)
    rescue StandardError
      return get_last_videos(count) if try_retry

      []
    end
  rescue StandardError
    puts 'Unrecoverable error'
    []
  end

  def try_retry
    if (@retry_count -= 1).positive?
      sleep 1
      puts 'Retrying'
      return true
    end

    @retry_count = 3
    puts 'Skipping after retries'
    false
  end

  def get_cards_infos(count)
    cards = []
    sleep(3)

    (0..count - 1).each do |card_index|
      card = get_single_card_info(card_index)
      cards.append(card)
    end

    cards
  end

  def get_single_card_info(id)
    card = "#{VIDEOS_LIST_ELEMENT}.childNodes[#{id}].querySelector('div')"
    sleep(1)
    title = @driver.execute_script("return #{card}.childNodes[1].querySelector('a div').textContent")
    description = @driver.execute_script("return #{card}.childNodes[2].querySelector('p').textContent")
    duration = @driver.execute_script("return #{card}.childNodes[3].childNodes[1].childNodes[1].textContent")
    date = @driver.execute_script("return #{card}.childNodes[3].childNodes[1].childNodes[0].textContent")

    video_txt = @driver.execute_script("return #{card}.childNodes[1].querySelector('a').getAttribute('href')")
    video_id = video_txt.sub(%r{/episode/}, '')

    SpotifyCardModel.new(title, description, duration, date, video_id)
  end
end
