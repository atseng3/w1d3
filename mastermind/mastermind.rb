require 'debugger'
class Mastermind
  COLORS = [:R, :G, :Y, :O, :P, :B]

  def initialize
    print "What's your name?"
    name = gets.chomp
    @human_player = Human.new(name)
    @comp_player = Computer.new()
    @num_moves = 0
    run_game
  end

  def run_game
    human_guess = ""
    until over?(human_guess)
      human_guess = @human_player.guess
      feedback(human_guess)
      @num_moves += 1
    end
    puts won?(human_guess) ? "You won!" : "You lost!"
  end

  def feedback(user_guess)
    #Black Dots for Correct Spot, Correct Color
    #Grey Dots for Correct Color, Wrong Spot
    #White Dots for Nothing Correct
    user_guess_duplicate = user_guess.dup
    # black dot check
    black_dot_counter = 0
    grey_dot_counter = 0
    comp_answer = @comp_player.answer
    # @comp_player.answer.each_with_index do |answer_peg, ans_index|
    # debugger
      user_guess.each_with_index do |guess_peg, guess_index|
        if user_guess[guess_index] == comp_answer[guess_index]
          black_dot_counter += 1
          user_guess_duplicate.delete(comp_answer[guess_index])
        elsif user_guess.include?(comp_answer[guess_index])
          grey_dot_counter += 1
          user_guess_duplicate.delete(comp_answer[guess_index])
        end
    end
    puts "#{black_dot_counter} black, #{grey_dot_counter} grey, #{user_guess_duplicate.length} white."
  end

  def over?(human_guess)
    won?(human_guess) || @num_moves == 10
  end

  def won?(human_guess)
    @comp_player.answer == human_guess
  end
end

class Human
  def initialize(name)
    @name = name
  end

  def guess
    loop do
      print "Please make a guess out of these colors: [R, G, B, Y, O, P]"
      user_guess = gets.chomp.upcase.split('')
      user_guess.map! { |peg| peg.to_sym }
      return user_guess if valid_move?(user_guess)
    end
  end

  def display(user_guess)
    print "Display: #{user_guess}"
  end

  def valid_move?(user_guess)
    return false unless user_guess.length == 4
    user_guess.all? { |peg| Mastermind::COLORS.include?(peg) }
  end
end

class Computer

  attr_reader :answer

  def initialize()
    @answer = gen_answer
  end

  def gen_answer
    Mastermind::COLORS.sample(4)
  end
end