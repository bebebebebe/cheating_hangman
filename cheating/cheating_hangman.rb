class GameState
  attr_accessor :turns_left, :letters_guessed, :revealed_word, :possible_words

  def initialize(turns_left, letters_guessed, revealed_word, possible_words)
    @turns_left = turns_left
    @letters_guessed = letters_guessed
    @revealed_word = revealed_word
    @possible_words = possible_words
  end

  def final_state?
    turns_left == 0 or revealed_word.count('_') == 0
  end

  def win? # is the final state a winning state for the human?
    revealed_word.count('_') == 0
  end

  def format_revealed_word
    spaced_word = (revealed_word.split('').map { |x| x + ' '}).join.strip
    ' '*10 + spaced_word + "\n\n"
  end
  
  def already_guessed?(letter) 
    letters_guessed.include? letter
  end

  def respond_to(guess)
    game_state = GameState.new(turns_left - 1, letters_guessed + [guess], update(revealed_word, biggest_partition_with(guess)), possible_words)
  end

  def update(word, partial)
    partial.each_char.with_index { |x,i| word[i] = partial[i] if x != '_' }
    word
  end

  def biggest_partition_with(guess) # guessed letter placement with most possible words
    key_value = partition_with(guess).max_by{ |k,v| v.size }
    @possible_words = key_value[1]
    key_value[0]
  end

  def partition_with(guess) # partition possible words by position(s) of guessed letter
    hash = Hash.new { |hash, key| hash[key] = [] }
    possible_words.each_with_object(hash) do |word, hash|
      hash[form(word, guess)] << word
    end
  end

  def form(word, letter)
    word.gsub(/[^#{letter}]/, '_')
  end

  def correct?(guess)
    biggest_partition_with(guess).include?(guess)
  end

  def secret_word # randomly select a possible word
    possible_words[rand(possible_words.length)]
  end

end


class Game
  attr_accessor :guess, :game_state
    
  def initialize
    word = dictionary[rand(dictionary.length)]
    @word_length = word.length
    @game_state = GameState.new(9, [], '_' * @word_length, word_list) 
  end

  def dictionary # 839 common words of length at most 7
    file = "../FREQ.TXT"
    File.read(file).split.select { |word| word == word.downcase and word.length < 8 }
  end

  def word_list
      dictionary.select { |word| word.length == @word_length }
    end
  
  def play
    until game_state.final_state?
      display_word
      get_guess
      process guess
      reply_to_guess
    end
      game_over
  end

  def display_word
    puts game_state.format_revealed_word
  end

  def get_guess
    loop do
      puts "You have #{game_state.turns_left} guesses left. Guess a letter:"; print '> '
      @guess = gets.downcase.chomp
      if game_state.already_guessed?(guess)
        puts "You already guessed '#{guess}'!"
      elsif not(('a'..'z').to_a.include? guess)
        puts "Just type in one letter (and then <return>)."
      else return guess
      end
    end
  end

  def process(guess)
    @game_state = game_state.respond_to(guess)
  end

  def reply_to_guess
    if game_state.correct?(guess)
      puts "Good guess!"
    else puts "Nope! The word doesn't contain #{guess}."
    end
  end

  def game_over
    if game_state.win?
      print 'You win! '
      else print 'You lose! '
      end
    puts "The word is: #{game_state.secret_word.upcase}"; puts
  end

end