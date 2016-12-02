# Demonstrates class inheritance with magazines, as a subset of publications
#

class Publication
  attr_accessor :publisher, :pub_date, :language
end

# The `<` syntax indicates that Magazine is extending, or is a sub-class
# of Publisher.
#
# the magazine has a publisher, pub_date, and language, as well as...
class Magazine < Publication
  attr_accessor :editor, :issue_number
end

# And this is a sub-class of Magazine, with the additional attr of URL
class Ezine < Magazine
  attr_accessor :url
end

# And this is a sub-class with no new attrs, but created because it is a
# technically a different type of publication.
class News_site < Ezine
end

mag = Magazine.new
mag.publisher = "Sean DMR"
mag.editor = "Sean Moran-Richards"
puts "Mag is published by #{mag.publisher} and edited by #{mag.editor}."
