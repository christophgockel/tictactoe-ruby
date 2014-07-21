class ComputerPlayer
  attr_reader :mark, :opponents_mark

  RatedMove = Struct.new(:score, :location)

  def initialize(mark, opponents_mark)
    @mark = mark
    @opponents_mark = opponents_mark
  end

  def next_move(board)
    best_move(board)
  end

  private

  def best_move(board)
    negamax(board, -1, 1, mark).location
  end

  def negamax(board, alpha, beta, mark)
    best_move = -1
    best_score = -1

    if board.is_completed?
      return RatedMove.new(score(board, mark), best_move)
    end

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
