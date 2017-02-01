# test places.rb

require './places.rb'
require './item_management.rb'
require './game.rb'

map = Map.new('central_corridor')

# this works for the class...
Map.scenes.each do |name, scene|
  puts "#{name}"
  # scene.enter
  puts "end #{name}\n----------"
end

## but it doesn't work for objects of the class
map.scenes.each do |name, scene|
  puts "testing #{name} scene\n"
  name.enter
  puts "end #{scene}\n----------"
end
