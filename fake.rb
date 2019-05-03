# fake.rb

######### begin fake Sinatra

def handle_request
  # pretending to be handling requests...
end

def get(path, &block)
  puts "[FAKE] registering new route: GET #{path}"
  loop { handle_request }
end

######### end fake Sinatra

get '/frank-says' do
  'Put this in your pipe & smoke it!'
end

puts 'this will never be executed..'

get '/time' do
  Time.now.to_s
end
