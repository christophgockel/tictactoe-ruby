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
    free_locations.size == 0
  end

  def set_move(location, mark)
    raise InvalidMove, "'#{location}' is not a valid move" if invalid_location(location)

    cells[internal_index(location)] = mark
  end

  def unset_move(location)
    cells[internal_index(location)] = nil
  end

  def free_locations
    cells.each_with_index.map { |cell, index| external_index(index) if cell.nil? }.compact
  end

  def is_completed?
    has_winner? || is_full?
  end

  def moves_made
    cells.size - free_locations.size
  end

  def has_winner?
    winning_constellations.any? { |row| row.uniq.length == 1 && row.all? }
  end

  def winner?(color)
    winning_constellations.any? { |row| row.all? { |cell| cell == color } }
  end

  class InvalidMove < ArgumentError; end

  def rows
    cells.each_slice(SIZE).to_a
  end

  private

  def internal_index(index)
    index - 1
  end

  def external_index(index)
    index + 1
  end

  def columns
    rows.transpose
  end

  def diagonals
    [] << rows.map.with_index do |row, index|
      row[index]
    end << rows.reverse.map.with_index do |row, index|
      row[index]
    end
  end

  def winning_constellations
    rows + columns + diagonals
  end

  def invalid_location(location)
    not_a_number?(location) || out_of_bounds?(location) || already_occupied?(location)
  end

  def not_a_number?(location)
    location.is_a?(Integer) == false
  end

  def out_of_bounds?(location)
    free_locations.include?(location) == false
  end

  def already_occupied?(location)
    cells[internal_index(location)].nil? == false
  end
end
