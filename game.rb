require 'board'
require 'rules'

class Game
  attr_reader :players, :board, :rules, :display

  def self.with_players(players)
    Game.new(players)
  end

  def self.prepare_new(players, display)
    Game.new(players, Board.new, Rules.new, display)
  end

  def initialize(players, board = nil, rules = nil, display = nil)
    @players = players
    @board   = board
    @rules   = rules
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

    rules.winner(board)
  end

  def game_is_ongoing
    !rules.has_winner?(board)
  end

  def display_board
    display.show_contents(board)
  end

  def place_move_of(player)
    board.set(player.next_move(board))
  end

  def switch_players
    players.reverse!
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
