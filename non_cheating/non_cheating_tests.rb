require './hangman.rb'
require 'minitest/autorun'

class GameTesting < MiniTest::Unit::TestCase

  def test_final_state?
    state1 = GameState.new(5, [], 'ab__t')
    state2 = GameState.new(0, [], 'ab__t')
    state3 = GameState.new(5, [], 'about')
    assert_equal(state1.final_state?, false)
    assert_equal(state2.final_state?, true)
    assert_equal(state3.final_state?, true)
  end

  def test_update
    state = GameState.new(5, [], 'ab__t')
    word = 'string'; letter = 'i'; string = 's_r__g' 
    assert_equal(state.update(string, letter, word), 's_ri_g')
  end

  def test_already_guessed
    state = GameState.new(5, ['a','b','t'], 'ab__t')
    assert_equal(state.already_guessed?('a'), true)
    assert_equal(state.already_guessed?('o'), false)
  end

  def test_respond_to_guess
    game_state = GameState.new(5, [], 'ab__t')
    guess = 'u'; word = 'about'
    game_state = game_state.respond_to_guess(guess,word)
    assert_equal(game_state.turns_left, 4)
    assert_equal(game_state.letters_guessed, ['u'])
    assert_equal(game_state.revealed_word, 'ab_ut')
  end

  def test_correct_guess?
    state = GameState.new(5, ['a','b','t'], 'ab__t')
    guess1 = 'u'; guess2 = 'c'; word = 'about'
    assert_equal(state.correct_guess?(guess1, word), true)
    assert_equal(state.correct_guess?(guess2, word), false)
  end

  def test_format_revealed_word
    state = GameState.new(5, [], 'ab__t')
    assert_equal(state.format_revealed_word, "          a b _ _ t" + "\n\n")    
  end

end
