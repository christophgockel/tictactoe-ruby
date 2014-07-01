Move = Struct.new(:symbol, :location)

class Board
  def initialize
    @cells = []
  end

  def empty?
    @cells.empty?
  end

  def set(move)
    @cells[move.location] = move.symbol
  end

  def rows
    rows = []

    @cells.each_slice(3) do |element|
      rows << element
    end

    rows
  end
end
