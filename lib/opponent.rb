require 'player'
require 'rules'

class Opponent
  attr_reader :player, :rules

  RatedMove = Struct.new(:score, :location)

  def initialize
    @rules = Rules.new
  end

  def next_move(player, board)
    @player = player.symbol

    best_move(board)
  end

  def best_move(board)
    move = negamax(board, -1, 1, player)
    return move.location
  end

  def negamax(board, alpha, beta, symbol)
    opponent = opponent(symbol)
    best_move = -1
    best_score = -1

    if rules.is_done?(board)
      return RatedMove.new(score(board, symbol), best_move)
    end

    locations = board.free_spots

    locations.each do |location|
      board.set(Move.new(symbol, location))
      score = -negamax(board, -beta, -alpha, opponent).score
      board.undo(location)

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

  def opponent(symbol)
    if symbol == Player::X
      Player::O
    else
      Player::X
    end
  end

  def score(board, symbol)
    winner = rules.winner(board)
    move_count = board.moves_made

    if winner == symbol
      return 1.0 / move_count
    elsif winner == opponent(symbol)
      return -1.0 / move_count
    else
      return 0.0
    end
  end
end
