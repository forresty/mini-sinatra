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
    @status = 200 # reset to default

    block, path_params = match_route(req)

    return not_found!(req, res) if block.nil?

    @params = req.query.merge(path_params)
    res.body = FakeSinatra.get_instance.instance_eval(&block).to_s
    res.status = @status # need to do this after evaluating the block
  end

  def register(method, path, block)
    @routes ||= {}
    @routes[path] ||= {}
    @routes[path][method] = block
  end

  private

  def status(code)
    @status = code
  end

  def params
    @params
  end

  def not_found!(req, res)
    method = req.request_method.to_sym

    res.status = 404
    res.body = "unknown route: #{method} #{req.path}"
  end

  def match_route(req)
    method = req.request_method.to_sym

    named_param = nil

    block = @routes.find { |path, _|
      pattern, named_param = to_pattern(path)
      pattern =~ req.path
    }[1][method] rescue nil

    # $1 will be the named param value
    [block, { named_param => $1 }.compact]
  end

  def to_pattern(path)
    # '/articles/' => %r{\A/articles/?\z}
    # '/articles/:id' => %r{\A/articles/([^/]+)/?\z}
    # '/restaurants/:id/comments' => %r{\A/restaurants/([^/]+)/comments/?\z}

    # remove trailing slashes then add named capture group
    path = path.gsub(/\/+\z/, '').gsub(/\:([^\/]+)/, '([^/]+)')

    # $1 will be the matched named param key if present
    [%r{\A#{path}/?\z}, $1]
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
