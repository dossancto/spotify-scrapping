require 'sinatra'
require_relative './controllers/podcasts_controller'

use PodcastsController

get '/frank-says' do
  'Put this in your pipe & smoke it!'
end
