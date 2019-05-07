# app.rb
require_relative 'fake_sinatra'
# require 'sinatra'

get '/articles/:id' do
  params
end

get '/restaurants/:id/comments' do
  params
end

post '/articles' do
  status 201
  params
end

get '/headers' do
  headers "X-Custom-Value" => "foo", "X-Custom-Value-2" => "bar"
  'ok'
end

get '/header' do
  headers "X-Custom-Value" => "This is a custom HTTP header."
  'ok'
end

get '/temp-redirect' do
  redirect 'http://google.com'
end

get '/perm-redirect' do
  redirect 'http://google.com', 301
end

get '/index' do
  erb :index
end

get '/time' do
  @time = Time.now
  erb :time
end
