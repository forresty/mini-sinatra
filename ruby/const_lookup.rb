# const_lookup.rb

class B
  def initialize
    puts "instance of ::B created"
  end
end

module A
  class B
    def initialize
      puts "instance of ::A::B created"
    end
  end

  class C
    def initialize
      @inner = B.new
      p @inner
      @outmost = ::B.new
      p @outmost
    end
  end
end

A::C.new
