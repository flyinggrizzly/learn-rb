# creates a mapping of state to abbrepviation
states = {
  'Oregon'     => 'OR',
  'Florida'    => 'FL',
  'California' => 'CA',
  'New York'   => 'NY',
  'Michigan'   => 'MI'
}

# create a basic set of states and some cities in them
cities = {
  'CA' => 'Los Angeles',
  'MI' => 'Ann Arbor',
  'FL' => 'Miami'
}

# add some more cities
cities['NY'] = 'Buffalo'
cities['OR'] = 'Portland'

# output some cities
puts '-' * 10
puts "NY State has: #{cities['NY']}"
puts "OR State has: #{cities['OR']}"

# output some states
puts '-' * 10
puts "Michigan's abbreviation is: #{states['Michigan']}"
puts "Florida's abbreviation is: #{states['Florida']}"

# do it gain by referencing in with the other hashmap
puts '-' * 10
puts "Michigan has: #{cities[states['Michigan']]}"
puts "Florida has: #{cities[states['Florida']]}"

# output each state abbreviation
puts '-' * 10
states.each do |state, abbrev|
  puts "#{state} is abbreviated #{abbrev}"
end

# output the cities
puts '-' * 10
cities.each do |abbrev, city|
  puts "#{abbrev} has #{city}"
end

# now do both at the same time
puts '-' * 10
states.each do |state, abbrev|
  city = cities[abbrev]
  puts "#{state} is abbreviated #{abbrev} and has #{city}"
end

puts '-' * 10
# by default ruby says "nil" when something isn't there
# state = state['Texas']

# if !state
  # puts "Sorry, no Texas"
# end

# default values using ||= with the nil result
city = cities['TX']
city ||= 'Des not exist'
puts "The city for the state 'TX' is; #{city}"
