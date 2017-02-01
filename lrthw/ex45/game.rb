require './elements.rb'
require './roles.rb'

class Game
  require './module_interactions.rb'
  include Interactions

  attr_reader :scoreboard, :player, :computer

  def initialize
    @game_descriptions = {
      1 => 'sudden death',
      3 => 'best 2 out of 3',
      5 => 'best 3 out of 5'
    }

    @scoreboard = {
      'player'   => 0,
      'computer' => 0
    }

    @judge = Judge.new
  end

  def define
    puts "How many rounds would you like to play?"
    @game_descriptions.each do |num_rounds, description|
      if num_rounds == 1
        puts "Length: #{num_rounds} round; '#{description}'."
      else
        puts "Length: #{num_rounds} rounds; '#{description}'."
      end
    end
    @game_length = prompt.to_i
  end

  def player_select
    @computer = Contestant.new('MCP')
    @player = Player.new
  end

  def set_up
    self.define
    self.player_select
  end

  def update_score(scorer)
    @scoreboard[scorer] += 1
  end

  def play
    puts "Let's get ready to RUUUUUMMMMMMBBBBBLLLLLLEEEEEE!!!!!!!"

    round_number = 0
    while round_number < @game_length

      puts "Round #{round_number}."
      puts "Rock, Paper, Scissors, SHOOT!"
      player_choice = @player.throw_shape
      computer_choice = @computer.throw_shape

      unless @judge.tied?(player_choice, computer_choice)
        if @judge.won?(player_choice, computer_choice)
          puts "You won! You picked #{player_choice}, and the computer picked #{computer_choice}!"
          update_score('player')
        else
          puts "You lost... the computer picked #{computer_choice} and you picked #{player_choice}."
          update_score('computer')
        end
      end
      puts "It was a tie! Next round!"
      round_number += 1
    end

    @judge.declare_winner(@scoreboard)
  end
end

game = Game.new
game.set_up
game.play
