class Ticket
  def initialize (venue,date)
    @venue = venue
    @date = date
    @price = price
  end

  def venue
    @venue
  end
  def date
    @date
  end
  def price
    @price
  end
  def price
    @price
  end
  
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
