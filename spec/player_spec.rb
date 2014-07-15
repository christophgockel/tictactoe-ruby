require 'spec_helper'

require 'player'
require 'io'


describe Player do
  let(:dummy_board) { double }

  it "has a mark" do
    player = Player.new("X")
    expect(player.mark).to eq "X"
  end

  it "asks an input object to get the next location" do
    input = double("Input", :next_location => 42)
    player = Player.new("X", input)
    player.next_move(dummy_board)

    expect(input).to have_received(:next_location).with(player.mark, dummy_board)
  end

  it "returns a Move when asked for it" do
    input = double("Input", :next_location => 6)
    player = Player.new("X", input)
    move = player.next_move(dummy_board)

    expect(move.mark).to eq "X"
    expect(move.location).to eq 6
  end

  it 'raises InvalidMove on invalid inputs' do
    input = double('input')
    allow(input).to receive(:next_location).and_raise(InvalidInput)
    player = Player.new("X", input)

    expect { player.next_move(double) }.to raise_error(Player::InvalidMove)
  end

  it 'has factory methods for creating a specific player' do
    expect(Player.X.mark).to eq Player::X
    expect(Player.O.mark).to eq Player::O
  end
end
