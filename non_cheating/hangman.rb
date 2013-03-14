# regular, non-cheating hangman. computer has secret word, human guesses.

class GameState
	attr_accessor :turns_left, :letters_guessed, :revealed_word

	def initialize(turns_left, letters_guessed, revealed_word)
		@turns_left = turns_left
		@letters_guessed = letters_guessed
		@revealed_word = revealed_word
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

	def update(string, letter, word)
		word.each_char.with_index { |x, i| string[i] = letter if x == letter }
		string
	end
	
	def already_guessed?(letter) 
		letters_guessed.include? letter
	end

	def respond_to_guess(guess, word)	
		game_state = GameState.new(turns_left - 1, letters_guessed + [guess], update(revealed_word, guess, word))
	end

	def correct_guess?(guess, word)
		word.count(guess) > 0
	end

end


class Game
	attr_accessor :word, :guess, :game_state
		
	def initialize(word_length = 5)
		@word = dictionary[rand(dictionary.length)]
		@game_state = GameState.new(9, [], '_' * @word.length )
	end


#############
	def dictionary # 839 common words of length at most 7
		file = "../FREQ.TXT"
		File.read(file).split.select { |word| word == word.downcase and word.length < 8 }
	end

# 	def word_list
#    		dictionary.select { |word| word.length == @word_length }
#   	end
# ###########


# 	def word_list(n)
# 		file = "../FREQ.TXT" # 985 frequent words (once proper names excluded)
# 		dictionary = File.read(file).split
# 		dictionary.select { |word| word.length == n }
# 	end	
	
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
		@game_state = game_state.respond_to_guess(guess, word)
	end

	def reply_to_guess
		if game_state.correct_guess?(guess, word)
			puts "Good guess!"
		else puts "Nope! The word doesn't contain #{guess}."
		end
	end

	def game_over
		if game_state.win?
			print 'You win! '
			else print 'You lose! '
			end
		puts "The word is: #{word.upcase}"; puts
	end

end