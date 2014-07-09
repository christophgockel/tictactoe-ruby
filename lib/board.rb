Move = Struct.new(:symbol, :location)

class Board
  SIZE = 3
  attr_reader :cells

  def initialize
    @cells = Array.new(SIZE * SIZE) { nil }
  end

  def empty?
    cells.all? { |e| e.nil? }
  end

  def is_full?
    free_spots.size == 0
  end

  def set(move)
    cells[move.location] = move.symbol
  end

  def undo(index)
    cells[index] = nil
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

  def free_spots
    spots = []

    rows.each_with_index do |row, row_index|
      row.each_with_index do |cell, column_index|
        spots << (row_index * SIZE + column_index) if cell.nil?
      end
    end

    spots
  end

  def moves_made
    rows.flatten.size - free_spots.size
  end

  def has_winner?
    has_winner_somewhere? {}
  end

  def winner
    the_winner = nil
    has_winner_somewhere? { |winner| the_winner = winner }
    the_winner
  end

  def is_done?
    has_winner? || is_full?
  end

  def has_winner_somewhere?(&block)
    has_winner_in_row?(&block) ||
    has_winner_in_column?(&block) ||
    has_winner_in_diagonal?(&block)
  end

  def has_winner_in_row?(&block)
    rows.any? do |row|
      line_has_winner?(row, &block)
    end
  end

  def has_winner_in_column?(&block)
    columns.any? do |column|
      line_has_winner?(column, &block)
    end
  end

  def has_winner_in_diagonal?(&block)
    diagonals.any? do |diagonal|
      line_has_winner?(diagonal, &block)
    end
  end

  def line_has_winner?(line, &block)
    if all_x?(line)
      block.call('x') if block_given?
      true
    elsif all_o?(line)
      block.call('o') if block_given?
      true
    end
  end

  def all_x?(line)
    line.all? { |cell| cell == 'x'  }
  end

  def all_o?(line)
    line.all? { |cell| cell == 'o' }
  end
end
