# fake_sinatra.rb
require 'webrick'

class FakeSinatra
  def self.get_instance(server=nil)
    @instance ||= new
  end

  def start
    @server = WEBrick::HTTPServer.new(Port: 4567)
    @server.mount('/', self.class)
    @server.start
  end

  def stop
    @server.stop
  end

  def service(req, res)
    method = req.request_method.to_sym
    res.body = "#{@routes[[method, req.path]].call} - served by FakeSinatra"
  end

  def register(method, path, block)
    @routes ||= {}
    @routes[[method, path]] = block
  end

  module Helpers
    %w{ get post patch put delete }.each do |method|
      define_method(method) do |path, &block|
        FakeSinatra.get_instance.register(method.upcase.to_sym, path, block)
      end
    end
  end
end

# so the user can call `get` etc
include FakeSinatra::Helpers

at_exit {
  exit if $! # really exit
  FakeSinatra.get_instance.start
}

[:INT, :TERM].each do |signal|
  trap(signal) {
    puts "SIG#{signal} caught, shutting down gracefully..."
    FakeSinatra.get_instance.stop
  }
end
