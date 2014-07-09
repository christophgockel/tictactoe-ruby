require 'player'

class Rules
  def has_winner?(board)
    has_winner_somewhere?(board) {}
  end

  def winner(board)
    the_winner = nil
    has_winner_somewhere?(board) { |winner| the_winner = winner }
    the_winner
  end

  def is_done?(board)
    has_winner?(board) || board.is_full?
  end

  def has_winner_somewhere?(board, &block)
    has_winner_in_row?(board, &block) ||
    has_winner_in_column?(board, &block) ||
    has_winner_in_diagonal?(board, &block)
  end

  def has_winner_in_row?(board, &block)
    board.rows.any? do |row|
      line_has_winner?(row, &block)
    end
  end

  def has_winner_in_column?(board, &block)
    board.columns.any? do |column|
      line_has_winner?(column, &block)
    end
  end

  def has_winner_in_diagonal?(board, &block)
    board.diagonals.any? do |diagonal|
      line_has_winner?(diagonal, &block)
    end
  end

  def line_has_winner?(line, &block)
    if all_x?(line)
      block.call(Player::X) if block_given?
      true
    elsif all_o?(line)
      block.call(Player::O) if block_given?
      true
    end
  end

  def all_x?(line)
    line.all? { |cell| cell == Player::X  }
  end

  def all_o?(line)
    line.all? { |cell| cell == Player::O }
  end
end
