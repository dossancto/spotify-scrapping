require './src/services/spotify_navigator'

spotify = SpotifyNavigator.new('6w9Fcpu5argDMKw73eigwj')
cards = spotify.get_last_videos
puts 'ALL CARDS RECEIVED'

cards.each do |card|
  puts card.title
  puts card.description
  puts "At #{card.date}, duration: #{card.duration}"
  puts "Link to video #{card.url_to_video}"
  puts ''
end
