# test/test_all.rb
require_relative 'helpers'

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

_, _, body = get('/index')
assert_match /works/, body

puts
puts
puts "all passed."
