require 'human_player'
require 'computer_player'
require 'delayed_computer_player'
require 'player_factory'

describe PlayerFactory do
  let(:display) { double.as_null_object }

  it 'supports human vs. computer' do
    players = PlayerFactory.create_pair(:human_computer, display)

    expect(players.first).to be_a_kind_of HumanPlayer
    expect(players.last).to be_a_kind_of ComputerPlayer
  end

  it 'supports human vs. human' do
    players = PlayerFactory.create_pair(:human_human, display)

    expect(players.first).to be_a_kind_of HumanPlayer
    expect(players.last).to be_a_kind_of HumanPlayer
  end

  it 'supports computer vs. human' do
    players = PlayerFactory.create_pair(:computer_human, display)

    expect(players.first).to be_a_kind_of ComputerPlayer
    expect(players.last).to be_a_kind_of HumanPlayer
  end

  it 'supports computer vs. computer' do
    players = PlayerFactory.create_pair(:computer_computer, display)

    expect(players.first).to be_a_kind_of DelayedComputerPlayer
    expect(players.last).to be_a_kind_of DelayedComputerPlayer
  end

  it 'throws exception for unknown pair types' do
    expect {
      PlayerFactory.create_pair(:unknown_pair_type, display)
    }.to raise_error PlayerFactory::UnknownPair
  end

  it 'returns information about what player pairs are possible' do
    expect(PlayerFactory.available_player_pairs).to eq([
      :human_human,
      :human_computer,
      :computer_human,
      :computer_computer
    ])
  end
end
