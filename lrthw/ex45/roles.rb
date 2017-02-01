require './elements.rb'

class Contestant
  attr_reader :name, :shapes

  def initialize(name)
    @name = name
    @shapes = ElemTable.new.get_shapes
  end

  def throw_shape
    # get a random number from 0 - 2
    random = rand(3)
    shape = @shapes[random]
    return shape
  end

end

class Player < Contestant
  require './module_interactions.rb'
  include Interactions

  def initialize
    puts "What is your name?"
    super(prompt)
  end

  def throw_shape

    puts "Which shape will you play?"
    @shapes.each_with_index do |shape, index|
      puts "#{index + 1}. #{shape.capitalize}"
    end

    shape = prompt.to_i - 1

    if shape == 0
      shape = 'rock'
    elsif shape == 1
      shape = 'paper'
    elsif shape == 2
      shape = 'scissors'
    else
      puts "err... we're playing with basic rules."
      self.throw_shape
    end

    return shape
  end
end

class Judge
  require './module_interactions.rb'
  include Interactions

  def initialize
    @shapes = ElemTable.new.get_shapes
  end

  # returns true if the first input wins, false if the second input wins, tie, for ties
  def tied?(a,b)
    if a == b
      true
    else
      false
    end
  end

  # accepts two inputs, returns true if the first wins, false if not
  def won?(a,b)
    @shapes.each_with_index do |attack, index|
      # the losing defense is always two steps away in the shape array, % 3
      defend = @shapes[(index + 2) % 3]
      if a == attack && b == defend
        true
      else
        false
      end
    end
  end

  def declare_winner(scoreboard)
    @scoreboard = scoreboard
    @players = @scoreboard.keys

    if @scoreboard[@players[0]] > @scoreboard[@players[1]]
      winner = @players[0]
    elsif @scoreboard[@players[0]] < @scoreboard[@players[1]]
      winner = @players[1]
    elsif @scoreboard[@players[0]] == @scoreboard[@players[1]]
      puts "It was a tie!"
    else
      put "... something went wrong..."
    end
    puts "#{winner} won!"
  end
end
