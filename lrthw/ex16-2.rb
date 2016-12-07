filename = ARGV.first

contents = open(filename)

puts "Here are the contents of your file:"
puts contents.read

contents.close
