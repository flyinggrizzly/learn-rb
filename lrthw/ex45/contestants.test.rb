# To do
# - test creation (name, shapes)
# - test shapes available
# - test name
# - test random shape choices
# - test user shape choices
require './contestants.rb'
checkmark = "\u2713".encode('utf-8')

class ContestTest

  def initialize
  end

  def test_inventory(contestant, expected_shapes)

    error_count = 0

    expected_shapes.each do |shape|
      if contestant.shapes.include? shape
        print checkmark
      else
        print 'X'
        error_count += 1
      end
    end

    if error_count == 0
      return true
    end
  end




  def test_name
  end

  def test_inventories(name, inventory_type)
    @name = name
    @inventory = inventory_type

    case @inventory
    when 'basic'
      contestant = Contestant.new(@name, @inventory)

      expected_shapes = []
      contestant.shapes.each

    when 'tos'

    when 'boom'

    when 'all'

    else
      # fail - bad inputs
    end
