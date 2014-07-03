require 'board'

class Player
  X = "x"
  O = "o"

  attr_reader :symbol

  def self.X(input = nil)
    Player.new(X, input)
  end

  def self.O(input = nil)
    Player.new(O, input)
  end

  def initialize(symbol, input = nil)
    @symbol = symbol
    @input = input
  end

  def next_move
    Move.new(@symbol, @input.next_move)
  end
end
