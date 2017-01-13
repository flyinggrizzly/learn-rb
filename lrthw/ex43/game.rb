require './item_management.rb'
require './player.rb'
require './places.rb'


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
      @inventory.list_all
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


obstacle_keys = RockPaperScissors.new()
# a_map = Map.new('central_corridor')
# a_game = Engine.new(a_map)
# a_game.play()
