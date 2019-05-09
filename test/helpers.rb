# test/helpers.rb

app_pid = fork {
  # will be run in the child process
  # parent never reaches here

  # silence webrick
  [$stdout, $stderr].each { |f| f.reopen("/dev/null", "w") }

  # start the app
  require_relative '../app.rb'
}

# will be run in the parent process
# child never reaches here

# ensure killing webrick even when errors are raised
at_exit {
  begin
    # run every method named "test_*"
    private_methods.grep(/\Atest_/).each do |test|
      method(test).call
    end
  ensure
    Process.kill(:INT, app_pid)
  end
  puts
  puts
  puts "all passed."
}

require 'net/http'

def request(method, path, body={})
  uri = URI("http://localhost:4567#{path}")
  res = case method
  when :get
    Net::HTTP.get_response(uri)
  when :post
    Net::HTTP.post_form(uri, body)
  else
    raise "method '#{method}' is not supported yet"
  end

  # status, headers, body
  [ res.code.to_i, Hash[res.each.to_a], res.body ]
rescue Errno::ECONNREFUSED
  sleep 1 # if webrick is not ready we try again later
  retry
end

def get(path)
  request(:get, path)
end

def post(path, body={})
  request(:post, path, body)
end

def assert_equal(expected, actual)
  assert expected == actual, "expecting #{expected.inspect}, got #{actual.inspect}"
end

def assert_match(pattern, actual)
  assert pattern =~ actual, "expecting #{actual.inspect} to match #{pattern.inspect}"
end

def assert(condition, message)
  raise message unless condition
  print '.'
end
