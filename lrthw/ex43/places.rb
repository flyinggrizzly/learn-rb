class Scene
  def enter()
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

    direction = $player.prompt.to_i

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
  def self.scenes
    @@scenes
  end

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
