class StandardIO
  attr_reader :input

  def initialize(input)
    @input = input
  end

  def next_move(player, board)
    input.gets
  end

  def show_contents(board)

  end
end
