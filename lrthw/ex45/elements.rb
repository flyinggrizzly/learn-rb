class Element
  attr_reader :strengths, :weaknesses, :name

  def initialize(name)
    @name = name
    @strengths = []
    @weaknesses = []
  end
end


class Rock < Element

  def initialize(name)
    super(name)
    @strengths.concat(['scissors'])
    @weaknesses.concat(['paper'])
  end
end

class Paper < Element

  def initialize(name)
    super
    @strengths.concat(['rock'])
    @weaknesses.concat(['scissors'])
  end
end

class Scissors < Element

  def initialize(name)
    super
    @strengths.concat(['paper'])
    @weaknesses.concat(['rock'])
  end
end

class ElemTable
  def initialize
    @elements = ['rock', 'paper', 'scissors']
  end

  def get_shapes
    @elements
  end
end
