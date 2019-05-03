# fake2.rb

def handle_request
  # pretending to be handling requests...
end

def get(path, &block)
  puts "[FAKE] registering new route: GET #{path}"
end

at_exit {
  puts "starting to listen for requests..."
  loop { handle_request }
}

######### end fake Sinatra

get '/frank-says' do
  'Put this in your pipe & smoke it!'
end

get '/time' do
  Time.now.to_s
end
