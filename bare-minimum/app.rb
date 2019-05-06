# app.rb
# require 'sinatra'
require_relative 'fake_sinatra'

# force webrick to log as verbose as possible
# https://github.com/ruby/ruby/blob/ruby_2_6/lib/webrick/server.rb#L91
# require 'webrick'
# set :server_settings, {
#   Logger: WEBrick::Log.new(nil, WEBrick::Log::DEBUG)
# }

get '/frank-says' do
  'Put this in your pipe & smoke it!'
end
get '/time' do
  Time.now.to_s
end
