require 'colorize'

require 'game_factory'

class CommandlineUI
  attr_reader :game, :stdout, :stdin, :use_color

  TEMPLATE_3X3 = <<-END.gsub(/^ {4}/, '')
     1 | 2 | 3
     --|---|--
     4 | 5 | 6
     --|---|--
     7 | 8 | 9
  END

  TEMPLATE_4X4 = <<-END.gsub(/^ {4}/, '')
     1  |  2  |  3  |  4
    ----|-----|-----|-----
     5  |  6  |  7  |  8
    ----|-----|-----|-----
     9  |  10 |  11 |  12
    ----|-----|-----|-----
     13 |  14 |  15 |  16
  END

  def initialize(game = nil, stdout = $stdout, stdin = $stdin)
    @game      = game
    @stdout    = stdout
    @stdin     = stdin
    @use_color = false
  end

  def run
    ask_for_game_type if no_game_available?

    while game.is_ongoing?
      display_board(game.board)
      place_next_move
    end
    display_board(game.board)

    display_game_result
  end

  def use_colors
    @use_color = true
    self
  end

  def ask_for_game_type
    stdout.puts 'Available game types:'
    stdout.puts '  (1) Human vs. Computer'
    stdout.puts '  (2) Human vs. Human'
    stdout.puts '  (3) Computer vs. Human'
    stdout.puts '  (4) Computer vs. Computer'

    @game = GameFactory.create_game(get_game_type)
  end

  def get_game_type
    choice = prompt_for_game_type
    case choice
    when 1
      :human_vs_computer
    when 2
      :human_vs_human
    when 3
      :computer_vs_human
    when 4
      :computer_vs_computer
    end
  end

  def prompt_for_game_type
    stdout.puts "Your choice: "
    choice = 0
    while is_valid_game_type_choice(choice) == false
      choice = stdin.gets.chomp.to_i
      stdout.puts 'Invalid choice' unless is_valid_game_type_choice(choice)
    end
    choice
  end

  def is_valid_game_type_choice(choice)
    (1..4).include? choice
  end

  def no_game_available?
    game.nil?
  end

  def display_board(board)
    stdout.puts "\e[H\e[2J"

    board_content = board.rows.flatten.each_with_index.map do |cell, index|
      cell ? cell : index + 1
    end

    template = template_for(board)

    board_content.each_with_index do |cell, index|
      replacement = value_for(cell, index)
      template = template.sub(/(?<= )#{index + 1}/, replacement)
    end

    stdout.puts colorize(template)
  end

  def colorize(template)
    return template unless use_color
    colored = template.clone

    colored.gsub!(/(\d)/, "\\1".light_black)
    colored.gsub!(/(#{game.players.first.mark})/, "\\1".green)
    colored.gsub!(/(#{game.players.last.mark})/, "\\1".magenta)
    colored
  end

  def template_for(board)
    board.size == 3 ? TEMPLATE_3X3.clone : TEMPLATE_4X4.clone
  end

  def value_for(cell, index)
    value = ''

    if index >= 9 && cell.to_s.length < 2
      value = "#{cell} "
    else
      value = cell.to_s
    end

    value
  end

  def place_next_move
    until prompt_for_move_and_place_it
      display_invalid_move_message
    end
  end

  def prompt_for_move_and_place_it
    display_next_move_prompt
    game.play_next_round

    game.round_could_be_played
  end

  def display_next_move_prompt
    stdout.puts "\nNext move:"
  end

  def display_invalid_move_message
    stdout.puts "Invalid move!"
  end

  def display_game_result
    if game.winner != ''
      stdout.puts "Winner is: #{game.winner}"
    else
      stdout.puts 'Game ended in a draw.'
    end
  end
end
