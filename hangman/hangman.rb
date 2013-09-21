#require 'debugger'

class Hangman
  def initialize
    init_players(welcome_message)
    # @secret_word = choose_word
    # @current_display = "_" * @secret_word.length
    run_game
  end

  def welcome_message
    puts "What game mode would you like to play?"
    puts "1) Human guesses Computer Word"
    puts "2) Computer guesses Human Word"
    puts "3) Human1 guesses Human2's word"
    puts "4) Computer tries to guess the other's word"
    choice  = gets.chomp
    # until (1..4).include?(choice)
#       puts "Please input a valid choice?"
#       choice = gets.chomp
#     end
#     choice
  end

  def init_players(choice_value)
    case choice_value
    when "1"
      @player1 = HumanPlayer.new
      @player2 = ComputerPlayer.new
    when "2"
      @player1 = ComputerPlayer.new
      @player2 = HumanPlayer.new
    when "3"
      @player1 = HumanPlayer.new
      @player2 = HumanPlayer.new
    when "4"
      @player1 = ComputerPlayer.new
      @player2 = ComputerPlayer.new
    end
  end

  def run_game
    secret_word_length = @player2.choose_word
    @player1.find_words_with_length(secret_word_length)

    until @player2.over?
      player1_guess = @player1.guess
      check_return = @player2.check(player1_guess)
      @player1.reduce_possible_solutions(check_return)
      display
      # puts display(@player1.guess)
    end
    "Congrats!"
  end

  def display
    puts @player2.current_display
  end

  # #########
  # def display(user_guess)
  #   letters_found = @secret_word.split('').map { |letter| user_guess == letter ? letter : "_" }
  #   @current_display.length.times do |i|
  #     @current_display[i] = (@current_display[i].ord + letters_found[i].ord - 95).chr
  #   end
  #   @current_display
  # end
  # ########
end

class Player
  attr_reader :current_display, :secret_word, :dictionary

  def initialize
    @secret_word = 'asdf'
    @current_display = "____"
  end

  def check(opponents_guess)
    # opponenets_guess = "s"
    letters_found = @secret_word.split('').map { |letter| opponents_guess == letter ? letter : "_" }
    @current_display.length.times do |i|
      @current_display[i] = (@current_display[i].ord + letters_found[i].ord - 95).chr
    end
    indices_of_guess = find_indices(opponents_guess)
    [opponents_guess, indices_of_guess]
  end

  def find_indices(letter)
    indices = @current_display.each_char.each_with_index.inject([]) do |indices, (char, idx)|
      indices << idx if char == letter
      indices
    end
    indices
  end

  def over?
    @secret_word == @current_display
  end
end

class HumanPlayer < Player
  attr_reader :name, :secret_word_length

  def initialize
    puts "What is your name?"
    @name = gets.chomp
    @dictionary = File.readlines("dictionary.txt").map! { |word| word.chomp.downcase }
  end

  def guess
    print "guess a letter: "
    user_guess = ''
    until user_guess.length == 1
      user_guess = gets.chomp.downcase
    end
    user_guess
  end

  def length_of_word
    puts "How long is the word?"
    @secret_word_length = gets.chomp.to_i
  end

  def choose_word
    length_of_word
    @secret_word = @dictionary.sample
    @secret_word = @dictionary.sample until @secret_word.length == @secret_word_length
    @current_display = "_" * @secret_word.length
    @secret_word.length
  end
end

class ComputerPlayer < Player
  attr_accessor :guessed_letters
  ALPHABET = ('a'..'z').to_a

  def initialize
    @guessed_letters = []
    @dictionary = File.readlines("dictionary.txt").map! { |word| word.chomp.downcase }
  end

  def choose_word()
    @secret_word = @dictionary.sample
    @current_display = "_" * @secret_word.length
  end

  def guess()
    choice = @possible_words_array.sample
    choice = choice.split('').sample
    while @guessed_letters.include?(choice)
      choice = @possible_words_array.sample
      choice = choice.split('').sample
    end
    @guessed_letters << choice
    puts "Computer chose: #{choice}."
    choice
  end

  def find_words_with_length(secret_word_length)
    @possible_words_array = @dictionary.select { |word| word.length == secret_word_length }
  end

  def reduce_possible_solutions(guess_and_indices)
    if guess_and_indices[1].nil?
      @possible_words_array.delete_if { |word| word.include?(guess_and_indices.first)}
    else
      guess_and_indices[1].each do |each_index|
        @possible_words_array.select! { |word| word[each_index] == guess_and_indices.first }
      end
    end
  end
end