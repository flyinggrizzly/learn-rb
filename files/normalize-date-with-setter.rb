class TravelAgentSession
  
  def year=(y)
    @year y.to_i
    if @year < 100
      @year = @year + 2000
    end
  end
end

# using a setter to filter and handle different possible styles of user input


