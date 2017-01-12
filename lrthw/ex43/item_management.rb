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

  attr_accessor :exists
  attr_reader   :name
end

class KeyItem < Thing

  def initialize(name, category)
    super(name)
    @category = category
  end

  attr_reader :category
end


# maps out which key items can unblock which types of blockers
class RockPaperScissors

  # get smart and make sure you only need to write out the block and key pairings once; the initialize function will reverse them for easier lookup
  def initialize

    @blockers_and_keys = {
      'door'        => 'key',
      'enemy'       => 'weapon',
      'class clown' => 'joke'
    }

    @keys_and_blockers = Hash.new()

    @blockers_and_keys.each do |blocker, key|
      #switch them so we get a new hash that's reversed of the original
      @keys_and_blockers[key] = blocker
    end
  end

  attr_reader :blockers_and_keys, :keys_and_blockers
end


# test: item_management-test.rb
