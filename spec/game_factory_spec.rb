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

  it 'can take another class for creating human players' do
    GameFactory.human_player_class = DummyHumanPlayer

    game = GameFactory.create_game(:human_vs_computer)

    expect(game.players.first).to be_a_kind_of DummyHumanPlayer
    expect(game.players.last).to be_a_kind_of ComputerPlayer
  end

  it 'can build games with a 3x3 board' do
    game = GameFactory.create_game(:human_vs_human, :board_3x3)
    expect(game.board.size).to eq 3
  end

  it 'can build games with a 4x4 board' do
    game = GameFactory.create_game(:human_vs_human, :board_4x4)
    expect(game.board.size).to eq 4
  end

  it 'uses a default board size of 3x3' do
    game = GameFactory.create_game(:human_vs_human)
    expect(game.board.size).to eq 3
  end

  class DummyHumanPlayer < HumanPlayer
  end
end
