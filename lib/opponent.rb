require 'player'
require 'rules'

class Opponent
  attr_reader :player, :rules

  RatedMove = Struct.new(:score, :location)

  def next_move(player, board)
    @player = player
    @rules = Rules.new

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
      score = -1 * negamax(board, -beta, -alpha, opponent(player)).score
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
    if player == Player::O
      return Player::X
    else
      return Player::O
    end
  end

  def score(board, player)
    moves_made = board.rows.flatten.size - board.free_spots.size
    winner = rules.winner(board)

    case winner
    when Player::X
      if player == Player::X
        return 1.0 / moves_made
      else
        return -1.0 / moves_made
      end
    when Player::O
      if player == Player::X
        return -1.0 / moves_made
      else
        return 1.0 / moves_made
      end
    else
      return 0.0
    end
  end
end
