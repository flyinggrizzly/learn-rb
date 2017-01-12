require './item_management.rb'
require './player.rb'



class Scene
  def enter()
  end
end


class Engine

  def initialize(scene_map, obstacle_keys)
    @map = scene_map
    @obstacle_keys = obstacle_keys

    puts "What is your name?"
    name = $stdin.gets.chomp

    @player = Player.new(name)
  end

  def prompt
    print "> "
    response = $stdin.gets.chomp

    if response == "inventory"
      player.inventory.list_all
      prompt
    else
      return response
    end
  end

  def play()
    current_scene = @map.opening_scene
    last_scene = @map.next_scene('escaped')

    while current_scene != last_scene
      next_scene_name = current_scene.enter()
      current_scene = @map.next_scene(next_scene_name)
    end

    # make sure you actually play the last scene
    current_scene.enter
  end
end

class Death < Scene

  def enter()
    puts "You died."
  end
end

class CentralCorridor < Scene

  def enter()
    puts "1. Straight. 2. Left. 3. Right."

    direction = a_game.prompt.to_i

    if direction == 1
      puts "Entering the escape pod room."
      return 'escape_pod_room'
    elsif direction == 2
      puts "Entering the bridge."
      return 'bridge'
    elsif direction == 3
      puts "Entering the armory."
      return 'armory'
    else
      return 'death'
    end
  end
end

class LaserWeaponArmory < Scene

  def enter()
    puts "Oooh. Look at the lasers. Those could do some damage...", "Better leave."
    return 'central_corridor'
  end
end

class TheBridge < Scene

  def enter()
    puts "So many BUTTONS!!!"
    puts "Prolly shouldn't touch any. Let's get outta here."
    puts "Hey wait, look, a key... that could be useful!"
    inventory.add_a('key', 'door')
    puts "*You picked up the key.*"
    return 'central_corridor'
  end
end

class EscapePod < Scene

  def enter()
    puts "So many escape pods!"
    puts "I'll get in that one."
    return 'escaped'
  end
end

class Escape < Scene

  def enter()
    puts "Whew. We made it. Hey, why is it so hot in here?"
    return 0
  end
end

class Map

  @@scenes = {
    'central_corridor'  => CentralCorridor.new(),
    'armory'            => LaserWeaponArmory.new(),
    'bridge'            => TheBridge.new(),
    'escape_pod_room'   => EscapePod.new(),
    'death'             => Death.new(),
    'escaped'           => Escape.new()
  }

  def initialize(start_scene)
    @start_scene = start_scene
  end

  def next_scene(scene_name)
    scene = @@scenes[scene_name]
    return scene
  end

  def opening_scene()
    return next_scene(@start_scene)
  end

end

# maps out which key items can unblock which types of blockers
class RockPaperScissors

  @@blockers_and_keys = {
    'door'        => 'key',
    'enemy'       => 'weapon',
    'class clown' => 'joke'
  }

  # get smart and make sure you only need to write out the block and key pairings once; the initialize function will reverse them for easier lookup
  def initialize

    @@keys_and_blockers = Hash.new()

    @@blockers_and_keys.each do |blocker, key|
      #switch them so we get a new hash that's reversed of the original
      @@keys_and_blockers[key] = blocker
    end
  end

end

class Inventory

  def initialize
    @@items = Hash.new(nil)
  end

  def add_a(name, type)
    item = KeyItem.new(name, type)
    @@items[name] = item
  end

  def list_all
    puts "*beep-boop* booting up inventory list..."
    @@items.each_with_index do |(name, type), index|
      puts "#{index}. #{key}, which is a #{type}."
    end
  end

  attr_accessor :items
end

obstacle_keys = RockPaperScissors.new()
a_map = Map.new('central_corridor')
a_game = Engine.new(a_map, obstacle_keys)
a_game.play()
