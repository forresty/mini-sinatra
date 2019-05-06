# return.rb

def magic!
  (1..1_000_000_000_000_000).each do |i|
    return i
  end
  return 'never reached!'
end

puts magic!
