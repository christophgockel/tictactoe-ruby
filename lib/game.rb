require 'board'

class Game
  attr_reader :players, :board, :display, :round_could_be_played

  class Over < RuntimeError
  end

  def initialize(player_one, player_two, board = nil)
    @players = [player_one, player_two]
    @board   = board || Board.new
    @round_could_be_played = false
  end

  def play_next_round
    raise Over if is_ongoing? == false

    place_move_of(players.first)
    switch_players
    @round_could_be_played = true
  rescue Board::InvalidMove
    @round_could_be_played = false
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
