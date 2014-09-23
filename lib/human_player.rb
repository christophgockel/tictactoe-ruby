class HumanPlayer
  attr_reader :mark, :input

  def initialize(mark, input)
    @mark = mark
    @input = input
  end

  def next_move(board)
    input.next_move
  end

  def ready?
    input.can_provide_next_move?
  end
end
