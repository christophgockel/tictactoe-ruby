class FakePlayer
  attr_reader :mark, :next_move_calls, :boards

  def initialize(mark, *next_moves)
    @mark = mark
    @next_moves = next_moves
    @next_move_calls = 0
    @board = nil
  end

  def next_move(board)
    @board = board
    @next_move_calls += 1

    @next_moves.shift
  end

  def next_move_has_been_called
    next_move_calls > 0
  end

  def passed_board
    @board
  end
end
