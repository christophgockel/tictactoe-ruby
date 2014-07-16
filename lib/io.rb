class CommandLineIO
  attr_reader :input, :output

  def initialize(input = $stdin, output = $stdout)
    @input = input
    @output = output
  end

  def next_location(player, board)
    output.puts "Next move for #{player}:"

    input.gets.to_i
  end

  def display_board(board)

    content = board.rows.map.with_index do |row, row_index|
      row.map.with_index do |cell, column_index|
        cell || (row_index*row.length) + column_index + 1
      end.join(' | ')
    end.join("\n---------\n")

    output.puts content
  end

  def display_invalid_move_message
    output.puts 'Invalid move.'
  end
end
