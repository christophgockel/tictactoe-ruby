class ComputerPlayer
  attr_reader :mark, :opponents_mark

  RatedMove = Struct.new(:score, :location)

  def initialize(mark, opponents_mark)
    @mark = mark
    @opponents_mark = opponents_mark
    @initial_moves_made = 0
  end

  def next_move(board)
    @initial_moves_made = board.moves_made
    return random_move(board) if move_doesnt_matter_in(board)
    return best_move(board)
  end

  def ready?
    true
  end

  private

  def random_move(board)
    board.free_locations.sample
  end

  def move_doesnt_matter_in(board)
    return false if board.size <= 3

    board.moves_made < 4
  end

  def best_move(board)
    negamax(board, -1, 1, mark).location
  end

  def negamax(board, alpha, beta, mark)
    best_move = -1
    best_score = -1

    return RatedMove.new(score(board, mark), best_move) if board_can_be_rated(board)

    locations = board.free_locations

    locations.each do |location|
      board.set_move(location, mark)
      score = -negamax(board, -beta, -alpha, opponent(mark)).score
      board.unset_move(location)

      if score > best_score
        best_score = score
        best_move = location
      end

      alpha = [score, alpha].max

      break if alpha >= beta
    end

    return RatedMove.new(best_score, best_move)
  end

  def board_can_be_rated(board)
    board.is_completed? || has_reasonable_state(board)
  end

  def has_reasonable_state(board)
    search_depth = board.moves_made - @initial_moves_made
    search_depth > 5
  end

  def opponent(mark)
    mark == @mark ? @opponents_mark : @mark
  end

  def score(board, mark)
    move_count = board.moves_made

    if board.winner?(mark)
      return 1.0 / move_count
    elsif board.winner?(opponent(mark))
      return -1.0 / move_count
    else
      return 0.0
    end
  end
end
