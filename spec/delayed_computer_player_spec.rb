require 'spec_helper'

require 'delayed_computer_player'
require 'fake_player'

describe DelayedComputerPlayer do
  subject { described_class.new(fake_player) }
  let(:fake_player) { FakePlayer.new('a', 8) }

  it_should_behave_like 'a player'
  before(:each) do
    allow(subject).to receive(:sleep)
  end

  it 'decorates a given player' do
    expect(subject.mark).to eq 'a'
    expect(subject.next_move(double)).to eq 8
  end

  it 'delays the next_move call' do
    subject.next_move(double)

    expect(subject).to have_received(:sleep)
  end
end
