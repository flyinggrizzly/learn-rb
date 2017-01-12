# test places.rb

require './places.rb'

# this works for the class...
Map.scenes.each do |name, scene|
  puts "#{name}"
end

## but it doesn't work for objects of the class
map = Map.new('central_corridor')
map.scenes.each do |name, scene|
  puts "testing #{name} scene\n"
  name.enter
  puts "end #{scene}\n----------"
end
