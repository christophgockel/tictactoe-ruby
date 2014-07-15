require 'board'
require 'io'

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
    Move.new(mark, input.next_location(mark, board))
  end

  Move = Struct.new(:mark, :location)

  class InvalidMove < RuntimeError
  end
end
