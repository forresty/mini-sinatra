# app.rb
require_relative 'fake_sinatra'

get '/articles' do
  'list all articles'
end

post '/articles' do
  'creating a new article'
end

# TODO: use pattern matching
delete '/articles/1' do
  'deleting a article'
end
