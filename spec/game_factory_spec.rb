require 'human_player'
require 'computer_player'
require 'delayed_computer_player'
require 'game_factory'

describe GameFactory do
  it 'supports human vs. computer' do
    game = GameFactory.create_game(:human_vs_computer)

    expect(game.players.first).to be_a_kind_of HumanPlayer
    expect(game.players.last).to be_a_kind_of ComputerPlayer
  end

  it 'supports human vs. human' do
    game = GameFactory.create_game(:human_vs_human)

    expect(game.players.first).to be_a_kind_of HumanPlayer
    expect(game.players.last).to be_a_kind_of HumanPlayer
  end

  it 'supports computer vs. human' do
    game = GameFactory.create_game(:computer_vs_human)

    expect(game.players.first).to be_a_kind_of ComputerPlayer
    expect(game.players.last).to be_a_kind_of HumanPlayer
  end

  it 'supports computer vs. computer' do
    game = GameFactory.create_game(:computer_vs_computer)

    expect(game.players.first).to be_a_kind_of DelayedComputerPlayer
    expect(game.players.last).to be_a_kind_of DelayedComputerPlayer
  end
end
