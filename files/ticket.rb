class Ticket
  def initialize(venue, date, price)
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
  
  def discount(percent)
    @price = @price * (100 - percent) / 100.0
  end
end

th = Ticket.new("Town Hall", "11/12/2013", 5.00)
puts "The firt is for a #{th.venue} event on #{th.date}, and it costs $#{"%.2f" % th.price}."
