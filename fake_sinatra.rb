# fake_sinatra.rb
require 'webrick'

class FakeSinatra
  def self.get_instance(server=nil)
    @instance ||= new
  end

  def service(req, res)
    res.body = "#{@routes[req.path].call} - served by FakeSinatra"
  end

  def register(path, block)
    @routes ||= {}
    @routes[path] = block
  end

  module Helpers
    def get(path, &block)
      FakeSinatra.get_instance.register(path, block)
    end
    # TODO: implement more HTTP methods
  end
end

# so the user can call `get` etc
include FakeSinatra::Helpers

at_exit {
  server = WEBrick::HTTPServer.new(Port: 4567)
  server.mount('/', FakeSinatra)
  server.start
}
