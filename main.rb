require_relative 'board'

# test = Board.new(12, 'Adam', 'Courtney', %w[Y O O B]) # %w[Y R B O]
# test.play_mastermind

def setup_game
  puts 'Welcome to Mastermind! Will you be playing with 1 or 2 players?'
  answer_valid = false
  until answer_valid
    answer = gets.chomp
    answer_valid = true if %w[1 2].include?(answer)
    puts 'Please enter 1 or 2!' unless answer_valid
  end
  if answer == '1'
    puts 'What is your name?'
    player = gets.chomp
    puts "Welcome #{player}!"
    puts 'How many guesses would you like on your board (8 - 12 recommended)?'
    board_length = get_number_value
    game = Board.new(board_length, player)
  else
    puts "What is the Code Breaker's name?"
    player = gets.chomp
    puts "Welcome #{player}!"
    puts "What is the Code Master's name?"
    master = gets.chomp
    puts "Welcome #{master}!"
    puts 'How many guesses would you like on your board (8 - 12 recommended)?'
    board_length = get_number_value
    puts "#{master} what is the code? Don't let #{player} see this: Options (Red, Blue, Yellow, Purple, Green, and Orange)\nValid formats are: r o y b or royb.\nCase doesn't matter" 
    game = Board.new(board_length, player, master, Board.get_valid_code(master, true))
    500.times { puts "LA LA LA CAN'T SEE THE CODE" }
  end
  game
end

def get_number_value # gets a valid integer greater than 1 from the user and returns it.
  answer_valid = false
  until answer_valid
    answer = gets.chomp
    answer_valid = true if answer.is_integer? && answer.to_i > 0
    puts 'Please enter a number greater than 0!' unless answer_valid
  end
  answer.to_i
end

class String
  # taken from https://stackoverflow.com/questions/1235863/how-to-test-if-a-string-is-basically-an-integer-in-quotes-using-ruby
  def is_integer?
    to_i.to_s == self
  end
end

setup_game.play_mastermind
