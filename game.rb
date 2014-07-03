require 'board'
require 'rules'

class Game
  attr_reader :players, :board, :rules

  def self.with_players(players)
    Game.new(players)
  end

  def initialize(players, board = nil, rules = nil)
    @players = players
    @board = board
    @rules = rules
  end

  def start
    ensure_enough_players

    while game_is_ongoing
      place_move_of(players.first)
      switch_players
    end
  end

  def game_is_ongoing
    !rules.has_winner?(board)
  end

  def place_move_of(player)
    board.set(player.next_move)
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
