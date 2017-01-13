class Player

  def initialize(name)
    @name = name
    @inventory = Inventory.new()

    puts "Do you know any jokes?"
    puts "1. Yes   2. No"
    knows_joke = self.prompt.to_i

    if knows_joke == 1
      @inventory.add_a('joke', 'joke')
    end

  end

  def prompt
    print "\n> "
    response = $stdin.gets.chomp

    if response == "inventory"
      @inventory.list_all
      prompt
    else
      return response
    end
  end

  attr_accessor :inventory
  attr_reader   :name
end
