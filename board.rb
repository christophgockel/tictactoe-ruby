Move = Struct.new(:symbol, :location)

class Board
  BOARD_SIZE = 3
  attr_reader :cells

  def initialize
    @cells = []
  end

  def empty?
    cells.empty?
  end

  def set(move)
    cells[move.location] = move.symbol
  end

  def rows
    rows = []

    cells.each_slice(BOARD_SIZE) do |element|
      rows << element
    end

    rows
  end

  def columns
    columns = []

    BOARD_SIZE.times do |column|
      columns << rows.map do |row|
        row[column]
      end
    end

    columns
  end
end
