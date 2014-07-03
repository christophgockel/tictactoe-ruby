Move = Struct.new(:symbol, :location)

class Board
  SIZE = 3
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

    cells.each_slice(SIZE) do |element|
      rows << element
    end

    rows
  end

  def columns
    columns = []

    SIZE.times do |column|
      columns << rows.map do |row|
        row[column]
      end
    end

    columns
  end

  def diagonals
    diagonals = []
    diagonal_1 = []
    diagonal_2 = []

    rows.each_with_index do |row, row_index|
      diagonal_1 << row[row_index]
      diagonal_2 << row[-1 - row_index]
    end

    diagonals << diagonal_1
    diagonals << diagonal_2

    diagonals
  end
end
