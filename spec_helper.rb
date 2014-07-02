def board_with(contents)
  board = Board.new

  contents.split('').each_with_index do |symbol, index|
    board.set(Move.new((symbol == ' ' ? nil : symbol), index))
  end

  board
end
