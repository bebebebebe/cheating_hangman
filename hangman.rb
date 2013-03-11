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
	
end


class Game
	attr_accessor :word, :guess
	#attr_writer :game_state
	
	
	def initialize(word_length = 5)
		def word_list(n)
			['cat', 'and', 'the', 'bat', 'can', 'bat'] if n == 3
			['today', 'robot', 'hello', 'camel', 'house', 'about'] if n == 5
		end
		@word = word_list(word_length)[rand(word_list(word_length).length)]
		@game_state = GameState.new(9, [], '_' * word_length )		
	end

	

	def play
		until @game_state.final_state?
			display_word
			get_guess
			process_guess(guess)
			reply_to_guess
		end
			game_over
	end

	def display_word
		print ' ' * 10

		@game_state.revealed_word.each_char { |x| print x; print ' ' }; puts		
	end

	def get_guess
		 # response = @game_state.respond_to_guess guess
		   # case response
		   # when :already_guessed
		   #    puts "You already guessed '#{guess}'!"
		   # when :guessed_correctly

		#

		loop do
			puts "You have #{@game_state.turns_left} guesses left. Guess a letter:"; print '> '
			@guess = gets.downcase.chomp
			if @game_state.letters_guessed.include? guess
				puts "You already guessed '#{guess}'!"
			elsif not(('a'..'z').to_a.include? guess)
				puts "Just type in one letter (and then <return>)"
			else return guess
			end
		end
	end

	def process_guess(letter)		
		@luck = word.count(letter) > 0 ? 'good' : 'bad'
	
		updated_word = update(@game_state.revealed_word, letter, word)
		@game_state = GameState.new(@game_state.turns_left - 1, @game_state.letters_guessed + [letter], updated_word)
	end

	def reply_to_guess
		if @luck == 'good'
			puts "Good guess!"
		else puts "Nope! The word doesn't contain #{guess}."
		end
	end

	def game_over
		if @game_state.win?
			print 'You win! '
			else print 'You lose! '
			end
		puts "The word is: #{word.upcase}"; puts
	end

	def update(string, letter, word)
		word.each_char.with_index { |x, i| string[i] = letter if x == letter }
		string
	end

end

game = Game.new
game.play

