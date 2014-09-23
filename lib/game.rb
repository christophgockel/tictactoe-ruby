require 'board'

class Game
  attr_reader :players, :board, :display, :round_could_be_played

  class Over < RuntimeError
  end

  class PlayerNotReady < RuntimeError
  end

  def initialize(player_one, player_two, board = nil, display = nil)
    @players = [player_one, player_two]
    @board   = board || Board.new
    @display = display
    @round_could_be_played = false

    update_display
  end

  def play_next_round
    raise Over if is_ongoing? == false

    place_move_of(players.first)
    switch_players
    update_display
    @round_could_be_played = true
  rescue Board::InvalidMove
    @round_could_be_played = false
    display.show_invalid_move_message
  rescue PlayerNotReady
    @round_could_be_played = false
    raise
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
    raise PlayerNotReady.new unless player.ready?

    move = player.next_move(board)
    board.set_move(move, player.mark)
  end

  def switch_players
    players.reverse!
  end

  def update_display
    display.show_board(board)

    if is_ongoing?
      display.announce_next_player(players.first.mark)
    elsif winner != ''
      display.announce_winner(winner)
    else
      display.announce_draw
    end
  end
end
