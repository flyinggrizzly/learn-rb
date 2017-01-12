class Thing

  def initialize(name)
    @name = name
    @exists = true
    @obtained = false
  end

  attr_accessor :obtained
  attr_reader :name
end

class KeyItem < Thing

  def initialize(name, unblocks)
    super(name)

    @unblocks = unblocks
  end

  attr_accessor :unblocks
end

thing = Thing.new('the thing')
key = KeyItem.new('the key', 'blockage')

puts thing.name
puts key.name
puts key.unblocks

key.unblocks = 'new blockage'

thing.obtained = true

if thing.obtained
  puts "I got the thing!"
end

puts key.unblocks
