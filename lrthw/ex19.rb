def cheese_and_crackers(cheese, crackers)
  puts "Cheese: #{cheese}"
  puts "Crackers: #{crackers}"
  puts "Enough for a party"
  puts "Get a blanket\n"
end

puts "We can just give the funciton numbers directly: "
cheese_and_crackers(20, 30)

puts "OR, we can use variables from our script:"
cheese = 10
crackers = 50

cheese_and_crackers(cheese, crackers)

puts "We can even do math inside too:"
cheese_and_crackers(10 + 20, 5 + 6)

puts "And we can combine passing variables and math, as well as new assignments:"
cheese_and_crackers(cheese = 100, crackers - 10)
