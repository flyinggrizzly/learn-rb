# Ex42

def prompt
  print "> "
  response = $stdin.gets.chomp
  return response
end

class Scene

  def enter()
  end

  @@description = "Woops. You shouldn't be here. It's like the room at the end of Chrono Trigger if you do *ALL* of the things, but we literally haven't done anything yet. It's not even a real scene... go away."
end

class Engine

  def initialize(scene_map)
  end

  def play()
  end
end

class Map

  def initialize( start_scene)
  end

  def next_scene( scene_name)
  end

  def opening_scene()
  end
end

class Thing

  def initialize()
    @exists = true
    @obtained = false
  end
end

class KeyItem < Thing

  def unblocks(blocker)
    @paired_lock = blocker
  end

end

class Death < Scene
  def enter()
    super
  end

  def die()
  end

  @description = "Oh no! Your face fell off and you realized you were an alien after all!"
end

class FirstCorridor < Scene
  def enter()
    puts "You walk down a long corridor.", "Do you go left or straight?"

    direction = prompt

    if direction == 'left'
      puts "You walk into the Escape Pod room. Good idea."
      return escape_pod_room
    elsif direction == 'straight'
      puts "You walk into an EVIL BOTHAN (No Mon Mothma!)."
      puts "1. What do you do? 2. Run back? 3. Run past it? 4. Crack a joke and pee?"
      choice = prompt.to_i
      if choice == 4
        return second_corridor
      else
        return death
      end

    else
      "Seriously. Two options, and either you can't type, or you're dumb. Die."
      return death
    end
  end
end

class EscapePod < Scene

  def enter()
    puts "There's a Bothan in the way. It's going to eat you."
    print "Unless you have something to shoot it with..."

    # this is hardcoded. BAD
    if a_laser.obtained
      puts "... oh good! You do! Shoot it!"
      puts "PEW PEW PEW PEW"
      puts "... it sizzled."
      puts "Get into the CHOPP-- err, ESCAPE POD. NOW!"
      return escaped
    else
      return death
    end

  end
end

class LaserWeaponArmory < Scene

  def enter()
    if a_door_key.obtained
      puts "You open the door with the key."
      puts "Hey look, a laser rifle!"
      puts "Cool. Better grab that!"
      a_laser.obtained = true
      puts "Once more into the breach!"
      return second_corridor
    else
      puts "Door is locked."
      puts "Back into the hallway sir, we must find the key!"
      return second_corridor
    end
  end
end

class Bridge < Scene

  def enter()
    puts "Wow... this place is really abandoned. We should really get offa this place before them aliums do a *real* number on it."
    puts "Should we have a poke around?"
    choice = prompt

    if choice == 'yes' || 'Yes' || 'y' || 'Y'
      puts "Good idea. Hey look, a key! (Talk about immediate payoff)"
      a_door_key.obtained = true
      puts "Time to get back out there and find a way offa this boat."
      return second_corridor
    else
      "Yea.. waste of time. Back out there to find a way off!"
      return second_corridor
    end
  end
end

class SecondCorridor < Scene

  def enter
    puts "You're further down the corridor. You can:"
    puts "1. Go back 2. Open the door on the left. 3. Open the door on the right."

    choice = prompt

    if choice == 1
      return first_corridor
    elsif choice == 2
      puts "Looks like that's the bridge."
      return bridge
    elsif choice == 3
      puts "Looks like the armory."
      return laser_weapon_armory
    else
      return death
    end
  end
end



a_map = Map.new('first_corridor')
a_joke = KeyItem.new.unblocks('first_bothan')
## turn this into a question before the game starts later on
a_joke.obtained = true
a_laser = KeyItem.new.unblocks('bothan_guarding_escape')
a_door_key = KeyItem.new.unblocks('laser_weapon_armory_door')
a_game = Engine.new(a_map)
a_game.play()
