# test

require './item_management.rb'

# this all works
inventory = Inventory.new()
inventory.add_a('item 1', 'foo')
inventory.add_a('item 2', 'bar')
# should list out the two items and their types
inventory.list_all

# this works
weapon_key = RockPaperScissors.new()
# should print out the blocker-key maps in both directions
weapon_key.blockers_and_keys.each do |blocker, key|
  puts "blocker: #{blocker}, opened by #{key}"
end
weapon_key.keys_and_blockers.each do |key, blocker|
  puts "key: #{key} removes #{blocker}"
end
