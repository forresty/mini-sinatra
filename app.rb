# app.rb
require 'sinatra'
get '/frank-says' do
  'Put this in your pipe & smoke it!'
end
get '/time' do
  Time.now.to_s
end
