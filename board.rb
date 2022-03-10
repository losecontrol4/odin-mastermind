#Class board the tools needed to play a game of mastermind.
class Board
  @@POSSIBLE_CHOICES = %w[R B Y P G O] #Red Blue Yellow Purple Green Orange
  def initialize(board_length, player = 'Code Breaker', codemaster = 'Code Master', code = Board.gen_code)
    @board_length = board_length 
    @player = player
    @codemaster = codemaster
    @code = code
    @gamewon = false
  end

  def self.gen_code #randomly generates a valid code
    code = []
    4.times { code.push(@@POSSIBLE_CHOICES[rand(0..(@@POSSIBLE_CHOICES.length - 1))]) }
    code
  end

  def play_mastermind # plays a round of mastermind, returns the name of the winner.
    welcome
    plural = false # for grammar purposes
    @board_length.times do |index|
      plural = true if index == @board_length - 1
      puts "#{@board_length - index} guess#{plural ? '' : 'es'} remain#{plural ? 's' : '' }!"
      guess_result = check_guess(Board.get_valid_code(@player, false))
      if guess_result == %w[∆ ∆ ∆ ∆]
        @gamewon = true
        break
      end
      puts guess_result.join(' ')
    end
    winner = @gamewon ? @player : @codemaster
    puts "the code was #{@code}"
    puts "#{winner} won!"
    winner
  end

  def self.get_valid_code(user, isMaster) #takes a value code from the user and returns it. Doing should just be "guess" or "code". 
    action = "guess"
    action = "code" if isMaster
    valid = false
    puts "#{user}, what's your #{action}?"
    until valid
      code = gets.chomp.upcase.split
      code = code[0].split('') if code.length == 1

      unless code.length == 4
        puts "#{user}, please give a #{action} with 4 colors like this 'R O P B'!"
        next
      end
      unless (code - @@POSSIBLE_CHOICES).empty?
        puts "Please enter valid colors, one letter each. Possible choices are #{@@POSSIBLE_CHOICES}"
        next
      end
      valid = true
    end
    code
  end

  private

  def welcome
    puts '-------------------------------------------------------------------------------------------------------------------------'
    puts "Welcome to mastermind. The goal of the game is simple,\nthe Code Breaker has to figure out the Code Master's code."
    puts "The Code Breaker will have #{@board_length} guesses to figure out the code."
    puts 'Each guess will reveal some information about the code to the Code Breaker.'
    puts 'They will learn if their guess had a color in the correct spot, or a color used in their guesses'
    puts "They won't learn which is right, just that something is."
    puts 'Colors rr can appear more than once in the code.'
    puts 'To make a guess, the Code Breaker will type in a guess using the first letter of the color guess.'
    puts 'Accepted formats can be like "R O Y B" or "royb" -uppercase/lowercase doesn\'t matter.'
    puts "∆ means that a color put was in the correct place. • means that a color you used is used in the code, but it is in the wrong place.\n- refers to one of the colors you used is not used."
    puts 'The order that these appear do not have any correlation with the order of the colors.'
    puts "#{@player} will now try to break the code!"
    puts '-------------------------------------------------------------------------------------------------------------------------'
  end

  def check_guess(guess_array)
    # assumes guess is valid
    result_array = []
    j_array = [] # created to help prevent the same color in the code being counted for something twice
    guess_array.each_with_index do |guess, i|
      pushed = false # keeps track if something was already pushed that go around (can't skip the rest unless it was a perfect match)
      @code.each_with_index do |code, j|
        next unless code == guess # Skips to next iteration

        if i == j
          result_array.pop if pushed
          j_array.pop if pushed
          if j_array.include?(j) # solves edge case where a letter in the code can be used for both a correct placement guess and a correct color guess.
            result_array.delete_at(result_array.find_index('•'))
          end
          result_array.push('∆')
          j_array.push(j)
          break # no longer need to check anymore in this pass
        end

        next if pushed || j_array.include?(j)

        result_array.push('•')
        j_array.push(j)
        pushed = true
      end
    end
    organize_result_array(result_array)
  end

  def organize_result_array(result_array)
    result_array = result_array.sort.reverse
    (4 - result_array.length).times { result_array.push('-') } if result_array.length < 4
    result_array
  end
end
