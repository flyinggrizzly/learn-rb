require "test/unit"

require "ex48/lexicon.rb"


class TestLexicon < Test::Unit::TestCase

  def test_directions
    assert_equal([['direction', 'north']], Lexicon.new.scan("north"))
    result = Lexicon.new.scan("north south east")

    assert_equal([
      ['direction', 'north'],
      ['direction', 'south'],
      ['direction', 'east'],
      ], result)
  end

  def test_verbs
    assert_equal([['verb', 'go']], Lexicon.new.scan('go'))

    expectation = [
      ['verb', 'go'],
      ['verb', 'kill'],
      ['verb', 'eat'],
    ]

    assert_equal(expectation, Lexicon.new.scan('go kill eat'))
  end

  def test_nouns
    assert_equal([['noun','bear']], Lexicon.new.scan('bear'))

    expectation = [
      ['noun', 'bear'],
      ['noun', 'princess'],
    ]

    assert_equal(expectation, Lexicon.new.scan('bear princess'))
  end

  def test_stop_words
    assert_equal([['stop', 'the']], Lexicon.new.scan("the"))

    expectation = [
      ['stop', 'the'],
      ['stop', 'in'],
      ['stop', 'of'],
    ]

    assert_equal(expectation, Lexicon.new.scan("the in of"))
  end

  def test_numbers
    assert_equal([['number', 1234]], Lexicon.new.scan("1234"))
  end

  def test_errors
    assert_equal([['error', 'ASDFASDFASDF']], Lexicon.new.scan("ASDFASDFASDF"))

    expectation = [
      ['noun', 'bear'],
      ['error', 'IAS'],
      ['noun', 'princess']
    ]

    assert_equal(expectation, Lexicon.new.scan("bear IAS princess"))
  end

end
