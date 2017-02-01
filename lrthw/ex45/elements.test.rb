require './elements.rb'
checkmark = "\u2713".encode('utf-8')

puts "testing Element class"

element = Element.new('Hydrogen')
puts element.name

puts "testing strength"
unless element.strengths.empty?
  puts "Fail"
else
  puts "Element class strengths OK"
end
puts "testing weakness"
unless element.weaknesses.length == 1
  puts "fail"
else
  puts "Element class weaknesses OK"
end
puts "Element class seems kosher."

puts "Testing child classes..."


rock = Rock.new('rock')
paper = Paper.new('paper')
scissors = Scissors.new('scissors')
# dynamite = Dynamite.new('dynamite')
# gorn = Gorn.new('gorn')
# kirk = Kirk.new('kirk')

elements = {
  rock.name => rock,
  paper.name => paper,
  scissors.name => scissors,
  # dynamite.name => dynamite,
  # gorn.name => gorn,
  # kirk.name => kirk
}

elements.each do |name, element|

  puts "Checking #{name}:"

  print "Number of strengths: #{element.strengths.length.to_s}... "

  strength_errors = 0

  element.strengths.each do |strength|

    # check whether or not this strength is listed as a weakness in the corresponding element object
    if elements[strength].weaknesses.include? element.name
      print checkmark, " "
    else
      puts "\n#{name}'s strength #{strength} is not listed as a weakness in the corresponding element #{strength}."
      error_count += 1
    end
  end

  if strength_errors == 0
    puts "Element #{name}'s strengths are all weaknesses in corresponding elements."
  end


  print "Number of weaknesses: #{element.weaknesses.length.to_s}... "

  weakness_errors = 0

  element.weaknesses.each do |weakness|

    # same check, but for the element's weaknesses
    if elements[weakness].strengths.include? element.name
      print checkmark, " "
    else
      puts "\n#{name}'s weakness #{weakness} is not listed as a strength in the corresponding element #{weakness}."
    end
  end

  if weakness_errors == 0
    puts "Element #{name}'s weaknesses are all strengths in corresponding elements."
  end

  puts "All elements checked"
end
