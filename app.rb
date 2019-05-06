# app.rb
require_relative 'fake_sinatra'

get '/inspect' do
  params
end
