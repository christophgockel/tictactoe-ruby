require 'player'

class Rules
  def has_winner?(board)
     has_winner_in_row?(board) || has_winner_in_column?(board) || has_winner_in_diagonal?(board)
  end

  def has_winner_in_row?(board)
    board.rows.any? do |row|
      line_has_winner?(row)
    end
  end

  def has_winner_in_column?(board)
    board.columns.any? do |column|
      line_has_winner?(column)
    end
  end

  def has_winner_in_diagonal?(board)
    board.diagonals.any? do |diagonal|
      line_has_winner?(diagonal)
    end
  end

  def line_has_winner?(line)
    line.all? { |cell| cell == Player::X || cell == Player::O }
  end
end
