require './hangman.rb'

word_length = 2 + rand(5)
puts word_length

game = Game.new(word_length)
game.play