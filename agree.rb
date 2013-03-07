# Cheating Hangman.
# Agreeable strategy: say guess correct if possible.

class GameState
	attr_reader :turns_left, :used_letters, :current_word

	def initialize(turns_left, used_letters, current_word)
		@turns_left = turns_left
		@used_letters = used_letters
		@current_word = current_word
	end

	def words_remaining
		current_word.split('').each.with_index.inject(WORD_LIST) do |list, (letter, position)|
			if letter != "_"
				list.select do |word|
					word[position] == letter
				end
			else
				list
			end
		end
	end

	def words_remaining_with letter
		letter = Regexp.new letter
		array = []
		words_remaining.each do |word|
			array << word if word =~ letter
		end
		array
	end

	def word_forms letter
		words = words_remaining_with letter
		array = words.map { |word| word.gsub(/[^#{letter}]/, '_') }
		array = array.uniq		
	end


	# assume word, form are strings of the same length. form's non-blanks are blanks in word.
	# combine by filling word's blanks with non-blanks in form.
	def combine word, form
		word = word.each_char.with_index { |x,i| word[i] = form[i] if form[i] != '_'  }
	end


	def blank_positions
		result = []
		i = -1
		while i = current_word.index('_', i+1)
			result << i
		end
		result
	end

	def blanks_remaining
		blank_positions.length
	end


	def win_with? guess
		ans = false
		for form in word_forms(guess)
			ans = true if GameState.new(turns_left - 1, used_letters + [guess], combine(current_word, form)).guaranteed_win?
			return true if ans == true
		end
		GameState.new(turns_left - 1, used_letters + [guess], current_word).guaranteed_win?
	end

	def guaranteed_win?
		if blanks_remaining == 1
			words_remaining.length > turns_left
		elsif (turns_left == 0 and blanks_remaining.length > 0)
			return true
		else letters_left = ('a'..'z').to_a - used_letters
			letters_left.each do |guess|
				return false if win_with? guess == false
			end
		end
	end
end



class Game
	attr_reader :game_state

	def initialize
		@game_state = GameState.new(1, [], "c__")
	end

	

	def testing
		# puts WORD_LIST.join(', '); puts '****'
		# puts game_state.words_remaining
		# puts '****'
		# puts game_state.words_remaining_with 'a'
		# puts '****'
		# puts game_state.word_forms 'a'
		#puts game_state.combine 'c___', '_a__'
		puts game_state.guaranteed_win?
	end

	def get_guess	# TODO complain if don't get letter, or get used letter
		puts 'Guess a letter:'; print '> '
		@guess = gets.chomp.downcase
	end
	
	
	def display_word
		game_state.current_word.each_char { |letter| print letter + " " }; puts
	end

end

WORD_LIST = ['cot', 'hot', 'cat', 'bat', 'bot', 'caa', 'cab']
game1 = Game.new
game1.testing