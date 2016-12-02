class Ticket
  # the previous version of this was hella repetitive, with a ton of
  # def foo/@foo/end's all over the place. This version uses `symbols`
  #
  attr_reader :venue, :date, :price
end

class Ticket
  def price=(amount)
    if (amount * 100).to_i == amount * 100
      @price = amount
    else
      puts "The price seems to be malformed"
    end
  end

  def discount(percent)
    @price = @price * (100 - percent) / 100.0
  end
end

ticket = Ticket.new("Town Hall", "11/11/11")
ticket.price = 63.00
puts "The ticket costs $#{"%.2f" % ticket.price}."
ticket.price = 72.5
puts "Whoops, the price just went up. It now costs $#{"%.2f" % ticket.price}."
