require 'simplecov'
SimpleCov.start

require 'board'

def board_with(contents)
  board = Board.new

  contents.split('').each_with_index do |symbol, index|
    board.set_move(index + 1, (symbol == ' ' ? nil : symbol))
  end

  board
end
