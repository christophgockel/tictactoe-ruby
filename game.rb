class Game
  def initialize
    @players = []
  end

  def start
    ensure_enough_players
  end

  def add_players(players)
    @players = players
  end

  class InsufficientPlayers < Exception
  end

  private

  def ensure_enough_players
    if @players.length != 2
      raise InsufficientPlayers
    end
  end
end
