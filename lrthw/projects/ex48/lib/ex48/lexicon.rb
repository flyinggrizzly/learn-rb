class Lexicon

  def initialize
    @directions = [
      ['direction', 'north'],
      ['direction', 'south'],
      ['direction', 'east'],
      ['direction', 'west'],
    ]

    @verbs = [
      ['verb', 'go'],
      ['verb', 'kill'],
      ['verb', 'eat'],
    ]

    @nouns = [
      ['noun', 'bear'],
      ['noun', 'princess'],
    ]

    @stop_words = [
      ['stop', 'the'],
      ['stop', 'in'],
      ['stop', 'of'],
    ]

    # create an array of all instance vars so we can loop in the scan method instead of explicitly checking each one. Only works if we instantiate the class everytime we need it, we can't call class or Singleton methods in the test. Could also create this array when the scan method starts, but it seems more appropriate to put it here.
    @dictionaries = []
    inst_var_names = instance_variables
    inst_var_names.each do |name|
      @dictionaries << self.instance_variable_get(name)
    end
  end

  def scan(input)
    # put all input arguments into array, even if there is only one. This means we don't have to code differently for single or multiple arguments.
    input = input.split
    keywords = []

    input.each do |arg|
      if convert_number(arg) != nil #handle numbers before looping over lexica
        keywords << ['number', convert_number(arg)]
      else
        arg_found = false
        @dictionaries.each do |dictionary|
          dictionary.each do |lex_item|
            if lex_item.include? arg.downcase
              keywords << lex_item
              arg_found = true
            end
          end
        end
        unless arg_found
          keywords << ['error', arg]
        end
      end
    end
    return keywords
  end # end scan

  def convert_number(object)
    begin
      return Integer(object)
    rescue
      return nil
    end
  end # end convert_number

end
