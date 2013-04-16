require './cheating_hangman.rb'
require 'minitest/autorun'

class GameTesting < MiniTest::Unit::TestCase

  def test_final_state?
    state1 = GameState.new(5, [], 'ab__t', ['about'])
    state2 = GameState.new(0, [], 'ab__t', ['about'])
    state3 = GameState.new(5, [], 'about', ['about'])
    assert_equal(state1.final_state?, false)
    assert_equal(state2.final_state?, true)
    assert_equal(state3.final_state?, true)
  end

  def test_already_guessed
    state = GameState.new(5, ['a','b','t'], 'ab__t', ['about'])
    assert_equal(state.already_guessed?('a'), true)
    assert_equal(state.already_guessed?('o'), false)
  end
  
  def test_format_revealed_word
    state = GameState.new(5, [], 'ab__t', ['about'])
    assert_equal(state.format_revealed_word, "          a b _ _ t" + "\n\n")    
  end

  def test_update
    state = GameState.new(5, [], 'ab__t', ['about'])
    assert_equal(state.update('ab__t', '___u_'), 'ab_ut')
  end

  def test_form
    state = GameState.new(5, [], 'ab__t', ['about'])
    assert_equal(state.form('abaut', 'a'), 'a_a__')   
  end

  def test_biggest_partition_with   
    state = GameState.new(5, [], 'ab__t', ['about', 'aboot', 'abort', 'abrot'])
    assert_equal(state.biggest_partition_with('o'), '__o__')
  end

  def test_respond_to
    state = GameState.new(5, [], 'ab__t', ['about', 'aboot', 'abort', 'abrot'])
    guess = 'o'
    state = state.respond_to(guess)
    assert_equal(state.turns_left, 4)
    assert_equal(state.letters_guessed, ['o'])
    assert_equal(state.revealed_word, 'abo_t')
    assert_equal(state.possible_words, ['about', 'abort'])
  end

end
