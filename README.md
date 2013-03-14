Cheating (and Non-Cheating) Hangman
===================

Two hangman games, both using a dictionary of about 1000 common words. The human is the player guessing letters.

Non-cheating hangman is just regular hangman. The computer picks a word at random from the word list, and the human guesses letters.

In cheating hangman, the computer "cheats" by having a set of possible words rather than one secret word. The set of possible words is the set of all dictioary words of a certain length at the start of the game, and is then updated based on the human's guesses.

How to update the possible words set based on a guessed letter? First partition the possible words according to position(s) of the guessed letter. Then choose a largest class from the partition as the new set of possible words. (It is still possible for the human to win.)