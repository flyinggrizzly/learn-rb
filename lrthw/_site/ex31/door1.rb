def door_1

  require "./messages.rb"

  puts "The room is shockingly bright, and as you look around you start noticing half-remembered faces."

  present_options("Run away", "Eat Elvis", "Lick your elbow", "Hit on *the* Madonna")

  celeb_room = get_choice

  if celeb_room
    puts "Oh... I didn't expect that."
  end

end
