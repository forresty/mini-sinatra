# test.rb

app_pid = fork {
  # will be run in the child process
  # parent never reaches here

  # silence webrick
  [$stdout, $stderr].each { |f| f.reopen("/dev/null", "w") }

  # start the app
  load 'app.rb'
}

# will be run in the parent process
# child never reaches here

# ensure killing webrick even when errors are raised
at_exit { Process.kill(:INT, app_pid) }

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

status, headers, body = get('/articles/1')
assert_equal 200, status
assert_equal %[{"id"=>"1"}], body

status, headers, body = get('/articles/1?foo=bar')
assert_equal 200, status
assert_equal %[{"foo"=>"bar", "id"=>"1"}], body

status, headers, body = get('/restaurants/233/comments')
assert_equal 200, status
assert_equal %[{"id"=>"233"}], body

status, headers, body = post('/articles')
assert_equal 201, status
assert_equal %[{}], body

status, headers, body = get('/non-existent')
assert_equal 404, status
assert_match /unknown/, body

_, headers, _ = get('/header')
# webrick turn headers into lowercase form
assert_match /custom/, headers['x-custom-value']

_, headers, _ = get('/headers')
assert_equal 'foo', headers['x-custom-value']
assert_equal 'bar', headers['x-custom-value-2']

status, _, _ = get('/temp-redirect')
assert_equal 302, status

status, headers, _ = get('/perm-redirect')
assert_equal 301, status
assert_equal 'http://google.com', headers['location']

puts
puts
puts "all passed."
