require "./messages.rb"
require "./door1.rb"
require "./worst-choice.rb"

puts "You enter a dark room with two doors. Do you go through door #1 or door #2?}"

door = get_choice

if door == 1
  door_1

elsif door == 2
  puts "You should really try door #1..."

  present_options("OK", "No")
  go_to_door_1 = get_choice

  if go_to_door_1 == 1
    door_1
  else
    worst_choice
  end

else
  worst_choice
end
