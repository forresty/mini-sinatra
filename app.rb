# app.rb
require_relative 'fake_sinatra'
# require 'sinatra'

# '/articles/:id' => %r{\A/articles/([^/]+)/?\z}
get '/articles/:id' do
  params
end

# '/restaurants/:id/comments' => %r{\A/restaurants/([^/]+)/comments/?\z}
get '/restaurants/:id/comments' do
  params
end

post '/articles' do
  status 201
  params
end
