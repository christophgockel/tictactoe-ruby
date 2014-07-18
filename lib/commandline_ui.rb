class CommandlineUI
  attr_reader :game, :stdout

  def initialize(game, stdout = $stdout)
    @game = game
    @stdout = stdout
  end

  def run
    while game.is_ongoing?
      stdout.puts "\e[H\e[2J"
      display_board(game.board)
      place_next_move
    end

    display_game_result
  end

  private

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
