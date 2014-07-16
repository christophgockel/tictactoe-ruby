class CommandlineUI
  attr_reader :game, :stdout

  def initialize(game, stdout = $stdout)
    @game = game
    @stdout = stdout
  end

  def run
    while game.is_ongoing?
    display_board(game.board)
    stdout.puts 'Next move:'
    game.play_next_round
    stdout.puts '*******************'
    end
    stdout.puts "Winner is: #{game.winner}"
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
end
