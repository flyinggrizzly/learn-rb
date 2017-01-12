# testing player.rb

require './item_management.rb'
require './player.rb'

player = Player.new('Mike')
# should ask you if you know a joke, then list your inventory. It should have only the joke
player.inventory.list_all

# should print out whatever you type
puts "tell me something"
foo = player.prompt
puts foo

# enter inventory here
# should list your inventory, then ask you again for input, then output that input
puts "type in inventory to see your inventory, after that tell me something else"
bar = player.prompt
puts bar
