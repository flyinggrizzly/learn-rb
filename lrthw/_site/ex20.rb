inputfile = ARGV.first

# prints entire contents of file
def printall(f)
  puts f.read
end

# moves read head to first line
def rewind(f)
  f.seek(0)
end

# pretends to print the line requested, just prings the line at the read head and spits out what is essentially an arbritrary number
def print_a_line(line_count, f)
  puts "#{line_count}: #{f.gets.chomp}"
end


current_file = open(inputfile)

printall(current_file)

puts "Now let's rewind, kind of like a tape."

rewind(current_file)

puts "Let's print three lines:"

current_line = 1
print_a_line(current_line, current_file)

current_line = current_line + 1
print_a_line(current_line, current_file)

current_line = current_line + 1
print_a_line(current_line, current_file)
