require 'board'

class Player
  X = "x"
  O = "o"

  attr_reader :mark, :input

  def self.X(input = nil)
    Player.new(X, input)
  end

  def self.O(input = nil)
    Player.new(O, input)
  end

  def initialize(mark, input = nil)
    @mark = mark
    @input = input
  end

  def next_move(board)
    Move.new(mark, input.next_move(self, board))
  end

  Move = Struct.new(:mark, :location)
end
