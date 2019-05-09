# test/test_all.rb
require_relative 'helpers'

def test_named_params
  status, headers, body = get('/articles/1')
  assert_equal 200, status
  assert_equal %[{"id"=>"1"}], body
end

def test_named_params_mixed_with_query_params
  status, headers, body = get('/articles/1?foo=bar')
  assert_equal 200, status
  assert_equal %[{"foo"=>"bar", "id"=>"1"}], body
end

def test_named_params_in_middle
  status, headers, body = get('/restaurants/233/comments')
  assert_equal 200, status
  assert_equal %[{"id"=>"233"}], body
end

def test_custom_status_code
  status, headers, body = post('/articles')
  assert_equal 201, status
  assert_equal %[{}], body
end

def test_404
  status, headers, body = get('/non-existent')
  assert_equal 404, status
  assert_match /unknown/, body
end

def test_custom_headers
  _, headers, _ = get('/header')
  # webrick turn headers into lowercase form
  assert_match /custom/, headers['x-custom-value']
end

def _test_multiple_custom_headers
  _, headers, _ = get('/headers')
  assert_equal 'foo', headers['x-custom-value']
  assert_equal 'bar', headers['x-custom-value-2']
end

def test_temporary_redirect
  status, _, _ = get('/temp-redirect')
  assert_equal 302, status
end

def test_permanent_redirect
  status, headers, _ = get('/perm-redirect')
  assert_equal 301, status
  assert_equal 'http://google.com', headers['location']
end

def test_erb
  _, _, body = get('/index')
  assert_match /works/, body
end
