require 'player'
require 'board'

class Game
  attr_reader :players, :board, :display

  def self.with_players(players)
    Game.new(players)
  end

  def self.prepare_new(players, display)
    Game.new(players, Board.new, display)
  end

  def initialize(players, board = nil, display = nil)
    @players = players
    @board   = board
    @display = display
  end

  def start
    begin
      ensure_enough_players

      display_board
      place_move_of(players.first)
      switch_players
    end while game_is_ongoing
    display_board

    winner_of_game
  end

  def game_is_ongoing
    board.is_completed? == false
  end

  def display_board
    display.show_contents(board)
  end

  def place_move_of(player)
    move = player.next_move(board)
    begin
    board.set_move(move.mark, move.location)
    rescue
    end
  end

  def switch_players
    players.reverse!
  end

  def winner_of_game
    if board.winner?(players.first.mark)
      players.first.mark
    elsif board.winner?(players.last.mark)
      players.last.mark
    else
      ''
    end
  end

  class InsufficientAmountOfPlayers < Exception
  end

  private

  def ensure_enough_players
    if players.length != 2
      raise InsufficientAmountOfPlayers
    end
  end
end
