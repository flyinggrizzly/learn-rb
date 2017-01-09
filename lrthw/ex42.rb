# Good thread on SO here: http://stackoverflow.com/questions/4967556/ruby-craziness-class-vs-object

## Animal is-a object look at the extra credit
class Animal
end

## ??
## Dog is-a Animal
class Dog < Animal

  def initialize(name)
    ## ??
    ## Dog has-a @name attribute
    @name = name
  end
end

## ??
## Cat is-a Animal
class Cat < Animal

  def initialize(name)
    ## ??
    ## Cat has-a @name attr
    @name = name
  end
end

## ??
## Person is-a Object
class Person

  def initialize(name)
    ## ??
    ## has-a name
    @name = name

    ## Person has-a pet of some kind
    @pet = nil
  end

  attr_accessor :pet
end

## ??
## is-a Person
class Employee < Person

  def initialize(name, salary)
    ## ?? hmm waht is this strange magic?
    ## Uses parent Person's method of the same name, `initialize`
    super(name)
    ## ??
    ## has-a salary
    @salary = salary
  end
end

## ??
## is-a Object
class Fish
end

## ??
## is-a Fish
class Salmon < Fish
end

## ??
## is-a Fish
class Halibut < Fish
end

## rover is-a Dog
rover = Dog.new("Mary")

## ??
## satan is-a Cat, and is an object
satan = Cat.new("Satan")

## ??
## mary is-a Person, and is an object
mary = Person.new("Mary")

## ??
## mary has-a satan
mary.pet = satan

## ??
## frank is-a(n) Employee, and implicitly has-a 120000 salary
frank = Employee.new("Frank", 120000)

## ??
## frank has-a rover
frank.pet = rover

## ??
## crouse is-a Salmon
crouse = Salmon.new()

## ??
## harry is-a Halibut
harry = Halibut.new()
