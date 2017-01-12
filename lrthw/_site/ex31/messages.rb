def prompt
  print "> "
end

# Displays a prompt and gets user's choice; validates for integers.
def get_choice
  prompt
  choice = Integer(gets) rescue false

  if choice
    return choice
  else
    puts "Please type a number to choose"
    get_choice
  end
end

# Prints options in ordered list. Requires at least two, and will print as many as given.
def present_options(one, two, *others)
  puts "Do you..."
  puts "1. #{one}?"
  puts "2. #{two}?"

  # We need to track which option we have now; starting at three as we've got 1 and 2 above
  option_number = 3
  # if we have other options, they are presented here.
  for option in others
    puts "#{option_number}. #{option}?"
    option_number += 1
  end
end

def send_message(message)
  puts message
end

def good_move(message)
  send_message(message + " Good job!")
end

def bad_move(message)
  send_message(message + " Bad move bro.")
end
