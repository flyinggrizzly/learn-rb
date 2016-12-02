class Person
  def set_name(string)
    puts "Setting person's name..."
    @name = string
  end

  def get_name
    puts "Returning the person's name..."
    @name
  end
end

joe = Person.new
joe.set_name("Joe")
puts joe.get_name



# what is going on? Let me tell you...
## 
# first, we declare a class of person...
# and give it a couple of methods
# watch the second method--it implicitly returns the '@name' var
# which is an instance var that is created by the *other*
# method here. Pretty cool huh?
