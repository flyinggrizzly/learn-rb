# declare a var that takes the first commandline arg as its value
filename = ARGV.first

# open the filepath in 'filename'; store the file in a var txt
txt = open(filename)

puts "Here's your file #{filename}:"
# print the contents of txt to screan with .read
print txt.read

txt.close

print "Type the filename again: "
# gets new input from $stdin and stores than in a new var
file_again = $stdin.gets.chomp

txt_again = open(file_again)

print txt_again.read
