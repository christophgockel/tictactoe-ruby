require 'board'

class Game
  attr_reader :players, :board, :display

  class Over < RuntimeError
  end

  def initialize(player_a, player_b, board = nil)
    @players = [player_a, player_b]
    @board   = board || Board.new
  end

  def play_next_round
    raise Over if is_ongoing? == false

    place_move_of(players.first)
    switch_players
  end

  def is_ongoing?
    board.is_completed? == false
  end

  def winner
    return players.first.mark if board.winner?(players.first.mark)
    return players.last.mark  if board.winner?(players.last.mark)
    ''
  end

  private

  def place_move_of(player)
    move = player.next_move(board)
    board.set_move(move, player.mark)
  end

  def switch_players
    players.reverse!
  end
end
