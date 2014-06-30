require 'rspec'

require 'game'

describe Game do
  it "can't be started with not enough players" do
    game = Game.new
    expect { game.start }.to raise_error(Game::InsufficientPlayers)
  end

  it "needs two players to be started" do
    game = Game.new
    game.add_players([double, double])
    game.start
  end
end
