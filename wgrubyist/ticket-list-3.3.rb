class Ticket
  # the previous version of this was hella repetitive, with a ton of
  # def foo/@foo/end's all over the place. This version uses `symbols`
  ####################################################################
  # Switch these out to use the attr_accessor for price instead
  ###################
  # attr_reader :venue, :date, :price # read only
  # attr_writer :price # read and write
  # ## ## ## ## ## ##
  attr_reader :venue, :date
  attr_accessor :price

  def initialize(venue,date)
    @venue = venue
    @date = date
  end
end

ticket = Ticket.new("Town Hall", "11/11/11")
ticket.price = 63.00
puts "The ticket costs $#{"%.2f" % ticket.price}."
ticket.price = 72.5
puts "Whoops, the price just went up. It now costs $#{"%.2f" % ticket.price}."
