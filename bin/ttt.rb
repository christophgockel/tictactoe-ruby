require 'game'
require 'player'
require 'opponent'
require 'board'


class StandardInput
  def next_move(player, board)
    puts "\nWhat's your next move?"
    gets.chomp.to_i
  end
end

class StandardOutput
  def show_contents(board)
    system 'clear'
    content = board.rows.map.with_index do |row, row_index|
      row.map.with_index { |cell, column_index| cell || (row_index*row.length) + column_index }.join(' | ')
    end.join("\n---------\n")

    puts content
  end
end

x = Player.X(StandardInput.new)
o = Player.O(Opponent.new)

begin
  game = Game.prepare_new([x, o], StandardOutput.new)

  puts 'winner is: ' + game.start
rescue Interrupt
end
