# fake3.rb

require 'webrick'

def get(path, &block)
  puts "[FAKE] registering new route: GET #{path}"
end

at_exit {
  server = WEBrick::HTTPServer.new(Port: 4567)
  server.start
}

get '/frank-says' do
  'Put this in your pipe & smoke it!'
end

get '/time' do
  Time.now.to_s
end
