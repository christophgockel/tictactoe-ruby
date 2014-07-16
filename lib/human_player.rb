class HumanPlayer
  attr_reader :mark, :input

  def initialize(mark, input = $stdin)
    @mark = mark
    @input = input
  end

  def next_move(board)
    input.gets.to_i
  end
end
