require 'player'
require 'rules'

class Opponent
  attr_reader :player, :rules

  RatedMove = Struct.new(:score, :location)

  def initialize
    @rules = Rules.new
  end

  def next_move(player, board)
    @player = player

    best_move_for(board)
  end


  def best_move_for(board)
    negamax(board, -1, 1, player).location
  end

  def negamax(board, alpha, beta, player)
    best_move = -1
    best_score = -1

    if rules.has_winner?(board)
      return RatedMove.new(score(board, player), best_move)
    end

    board.free_spots.each do |index|
      board.set(Move.new(player, index))
      score = -negamax(board, -beta, -alpha, opponent(player)).score
      board.undo(index)

      if score > best_score
        best_score = score
        best_move = index
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

  def opponent(player)
    player == Player::X ? Player::O : Player::X
  end

  def score(board, player)
    moves_made = board.rows.flatten.size - board.free_spots.size
    winner = rules.winner(board)

    return 0.0 if winner.nil?

    score = 1.0 / moves_made

    if player != winner
      score = -score
    end

    return score
  end
end
