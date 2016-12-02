class Person
  def species
    "Homo sapiens"
  end
end

class Rubyist < Person
end

sean = Rubyist.new
puts sean.species
