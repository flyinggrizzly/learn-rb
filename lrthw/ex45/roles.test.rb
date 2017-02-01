require './roles.rb'

class ContestantTest

  def initialize
    @test_subject = Contestant.new('MCP')
    @acceptable_shapes = ['rock', 'paper', 'scissors']
    @object_type = 'Contestant'
  end

  def test_object_shapes
    if @test_subject.shapes != ['rock', 'paper', 'scissors']
      puts "#{@object_type} 'shapes' attribute isn't working."
    end
  end

  def test_object_name
    if @test_subject.name != 'MCP'
      puts "#{@object_type} 'name' attribute isn't working."
    end
  end

  def throw_shapes_test
    puts "Testing the throw_shapes method for CPU contestants 100 times... can't prove a negative!"

    error_count = 0
    (1..100).each do
      if @acceptable_shapes.include? @test_subject.throw_shape
        print '.'
      else
        print 'F'
        error_count += 1
      end
    end

    if error_count == 0
      puts "It *seems* like the throw_shape method works."
    end
  end
end

class PlayerTest < ContestTest

  def initialize
    super
    @object_type = 'Player'
  end

  def test_object_shapes
    super
  end

  def test_object_name
    puts "Is '#{@test_subject.name}' the name you gave just now?"
    puts "1. Yes."
    puts "2. No."
    response = prompt.to_i

    if response != 1
      puts "Name attribute isn't working."
    end
  end



  def throw_shapes_test




puts "Testing Contestant class:"
contestant = Contestant.new('MCP')
puts "Computer is playing as #{contestant.name}. Let's test the random number generator. Going to run it 100 times and see if it throws a response other than rock, paper, or scissors (like a no Class error)."

acceptable_shapes =

error_count = 0
(1..100).each do
  if acceptable_shapes.include? contestant.throw_shape
    print '.'
  else
    print 'F'
    error_count += 1
  end
end
if error_count == 0
  puts " All OK."
end

puts "Testing the Player class:"
player = Player.new << 'Tron'
puts player.name

error_count = 0 #reset error count
acceptable_shapes.each do |shape|

  puts "When I ask for a shape, please give me #{shape}."
  if acceptable_shapes[player.throw_shape] == shape
    print 'Great. '
  else
    puts "That wasn't a #{shape}; did you goof or is the code bad?"
    error_count += 1
  end
end
if error_count == 0
  puts " All OK."
end
