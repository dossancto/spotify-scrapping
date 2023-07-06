require './src/services/spotify_navigator'

nav = SpotifyNavigator.new('6w9Fcpu5argDMKw73eigwj')
cards = nav.get_last_videos
puts 'ALL CARDS RECEIVED'

cards.each do |card|
  puts card
  puts "Link to video #{card.url_to_video}"
end
