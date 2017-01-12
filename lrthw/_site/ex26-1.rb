# Just require the ex25.rb file that's just next door instead of writing all that mess out. Plus, I already fixed it in ex26.rb.
## Should probably learn the difference between 'require' and 'require_relative'
### Instead of requiring a file relative to the project's directory, it requires it relative to the current file's directory.
require_relative "ex25.rb"


puts "Let's practice everything."
puts 'You\'d need to know \'bout escapes with \\ that do \n newlines and \t tabs.'

poem = <<END
\tThe lovely world
with logic so firmly planted
cannot discern \n the needs of love
nor comprehend passion from intuition
and requires an explanation
\n\t\twhere there is none.
END

puts "--------------"
puts poem
puts "--------------"


five = 10 - 2 + 3 - 6
puts "This should be five: #{five}"

def secret_formula(started)
  jelly_beans = started * 500
  jars = jelly_beans / 1000
  crates = jars / 100
  return jelly_beans, jars, crates
end


start_point = 10000
beans, jars, crates = secret_formula(start_point)

puts "With a starting point of: #{start_point}"
puts "We'd have #{beans} beans, #{jars} jars, and #{crates} crates."

start_point = start_point / 10
puts "We can also do it this way:"
puts "We'd have %s beans, %d jars, and %d crates." % secret_formula(start_point)


sentence = "All good things come to those who wait."
words = Ex25.break_words(sentence)
sorted_words = Ex25.sort_words(words)

Ex25.print_first_word(words)
Ex25.print_last_word(words)
Ex25.print_first_word(sorted_words)
Ex25.print_last_word(sorted_words)
sorted_words = Ex25.sort_sentence(sentence)
Ex25.print_first_and_last(sentence)
Ex25.print_first_and_last_sorted(sentence)
