# test places.rb

require './places.rb'

Map.scenes.each do |name, scene|
  puts "#{name}"
end

map = Map.new('central_corridor')
map.scenes.each do |name, scene|
  puts "testing #{name} scene\n"
  name.enter
  puts "end #{scene}\n----------"
end
