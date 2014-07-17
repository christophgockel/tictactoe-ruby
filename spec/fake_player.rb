class FakePlayer
  attr_reader :mark

  def initialize(mark, *next_moves)
    @mark = mark
    @next_moves = next_moves
  end

  def next_move(board)
    @next_moves.shift
  end
end
