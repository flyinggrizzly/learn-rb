def prompt
  print "> "
  input = $stdin.gets.chomp
  return input
end

def dead(why)
  print why, "  :sad trombone:"
  exit(0)
end

def char_says(speech)
  print "> "
  puts speech
end
