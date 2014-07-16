class ComputerPlayer
  attr_reader :mark

  RatedMove = Struct.new(:score, :location)

  def initialize(mark)
    @mark = mark
  end

  def next_move(board)
    best_move(board)
  end

  private

  def best_move(board)
    move = negamax(board, -1, 1, mark)
    return move.location
  end

  def negamax(board, alpha, beta, mark)
    opponent = opponent(mark)
    best_move = -1
    best_score = -1

    if board.is_completed?
      return RatedMove.new(score(board, mark), best_move)
    end

    locations = board.free_locations

    locations.each do |location|
      board.set_move(location, mark)
      score = -negamax(board, -beta, -alpha, opponent).score
      board.unset_move(location)

      if score > best_score
        best_score = score
        best_move = location
      end

      if score > alpha
        alpha = score
      end

      if alpha >= beta
        break
      end
    end

    return RatedMove.new(best_score, best_move)
  end

  def opponent(mark)
    if mark == 'x'
      'o'
    else
      'x'
    end
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
