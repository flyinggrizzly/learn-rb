user_name = ARGV.first #gets the first arg
prompt = "> "

puts "Hi #{user_name}."
puts "I'd like to ask you a few questions."
puts "Do you like me #{user_name}."
print prompt
likes = $stdin.gets.chomp

puts "Where do you live #{user_name}?"
print prompt
lives = $stdin.gets.chomp

# a comma for puts is like using it twice

puts "What kind of computer do you have?"
# this was originally commad in the puts. Changed to print because the newline was weird after a prompt...
print prompt

computer = $stdin.gets.chomp

puts """
Alright so you said #{likes} about liking me.
You live in #{lives}.
And you have a #{computer} computer. Nice.
"""
