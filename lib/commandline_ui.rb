require 'game_factory'

class CommandlineUI
  attr_reader :game, :stdout, :stdin

  def initialize(game = nil, stdout = $stdout, stdin = $stdin)
    @game = game
    @stdout = stdout
    @stdin = stdin
  end

  def run
    ask_for_game_type if no_game_available?

    while game.is_ongoing?
      stdout.puts "\e[H\e[2J"
      display_board(game.board)
      place_next_move
    end

    display_game_result
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
    content = board.rows.map.with_index do |row, row_index|
      row.map.with_index do |cell, column_index|
        cell || (row_index*row.length) + column_index + 1
      end.join(' | ')
    end.join("\n---------\n")

    stdout.puts content
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
