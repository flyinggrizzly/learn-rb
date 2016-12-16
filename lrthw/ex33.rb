i = 0
numbers = []

def while_loop(num, limit, numbers)
  while num < limit
    puts "Iteration #{num}; i is #{num}"
    numbers.push(num)

    num += 1
    puts "Numbers now:", numbers
    puts "Ending iteration #{num - 1}, i is #{num}"
  end
  return num
end

while_loop(i, 6, numbers)

puts "The numbers: "

# remember, you can write this 2 other ways?
numbers.each {|num| puts num }
# or
# for num in numbers
#   puts num
# end
# or
# numbers.each |num|
#   puts num
# num
