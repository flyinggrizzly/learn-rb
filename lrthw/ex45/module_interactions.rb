module Interactions

  def prompt
    print "> "
    response = $stdin.gets.chomp
    print "\n"
    return response
  end
end
