require 'human_player'
require 'computer_player'
require 'delayed_computer_player'
require 'game_factory'

describe GameFactory do
  let(:display) { double.as_null_object }

  it 'supports human vs. computer' do
    game = GameFactory.create_game(:human_computer, :board_3x3, display)

    expect(game.players.first).to be_a_kind_of HumanPlayer
    expect(game.players.last).to be_a_kind_of ComputerPlayer
  end

  it 'supports human vs. human' do
    game = GameFactory.create_game(:human_human, :board_3x3, display)

    expect(game.players.first).to be_a_kind_of HumanPlayer
    expect(game.players.last).to be_a_kind_of HumanPlayer
  end

  it 'supports computer vs. human' do
    game = GameFactory.create_game(:computer_human, :board_3x3, display)

    expect(game.players.first).to be_a_kind_of ComputerPlayer
    expect(game.players.last).to be_a_kind_of HumanPlayer
  end

  it 'supports computer vs. computer' do
    game = GameFactory.create_game(:computer_computer, :board_3x3, display)

    expect(game.players.first).to be_a_kind_of DelayedComputerPlayer
    expect(game.players.last).to be_a_kind_of DelayedComputerPlayer
  end

  it 'throws exception for unknown game types' do
    expect {
      GameFactory.create_game(:unknown_game_type, :board_3x3, display)
    }.to raise_error GameFactory::UnknownGameType
  end

  it 'can build games with a 3x3 board' do
    game = GameFactory.create_game(:human_human, :board_3x3, display)
    expect(game.board.size).to eq 3
  end

  it 'can build games with a 4x4 board' do
    game = GameFactory.create_game(:human_human, :board_4x4, display)
    expect(game.board.size).to eq 4
  end

  it 'uses a default board size of 3x3' do
    game = GameFactory.create_game(:human_human, nil, display)
    expect(game.board.size).to eq 3
  end

  it 'returns information about what board sizes are possible' do
    expect(GameFactory.available_board_sizes).to eq({
      :board_3x3 => '3x3',
      :board_4x4 => '4x4'
    })
  end

  it 'returns information about what board sizes are possible' do
    expect(GameFactory.available_game_types).to eq([
      :human_human,
      :human_computer,
      :computer_human,
      :computer_computer
    ])
  end
end
