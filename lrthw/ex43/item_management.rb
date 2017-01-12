class Inventory

  def initialize
    @@items = Hash.new(nil)
  end

  def add_a(name, category)
    item = KeyItem.new(name, category)
    @@items[name] = category
  end

  def list_all
    puts "*beep-boop* booting up inventory list..."
    @@items.each_with_index do |(name, category), index|
      puts "#{index + 1}. #{name}, which is a #{category}."
    end
  end

  attr_accessor :items
end

class Thing

  def initialize(name)
    @name = name
    @exists = true
  end

  attr_reader :name
end

class KeyItem < Thing

  def initialize(name, category)
    super(name)
    @category = category
  end

  attr_reader :category
end

# test
inventory = Inventory.new()
inventory.add_a('item 1', 'foo')
inventory.add_a('item 2', 'bar')
inventory.list_all
