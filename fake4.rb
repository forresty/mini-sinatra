# fake4.rb
require 'webrick'

class FakeSinatra
  # no need to inherit from WEBrick::HTTPServlet::AbstractServlet
  def self.get_instance(server)
    new
  end

  def service(req, res)
    res.body = 'hello world'
  end
end

def get(path, &block)
  puts "[FAKE] registering new route: GET #{path}"
end

at_exit {
  server = WEBrick::HTTPServer.new(Port: 4567)
  server.mount('/', FakeSinatra)
  server.start
}

get '/frank-says' do
  'Put this in your pipe & smoke it!'
end

get '/time' do
  Time.now.to_s
end
