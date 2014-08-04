class GuiPlayer
  attr_reader :mark
  attr_accessor :next_move_to_play

  def initialize(mark)
    @mark = mark
  end

  def next_move(board)
    next_move_to_play
  end
end
