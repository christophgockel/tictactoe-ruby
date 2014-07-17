require 'spec_helper'

require 'fake_player'

describe FakePlayer do
  subject { described_class.new('a', 1, 2, 3) }
  it_behaves_like 'a player'

  it 'can provide moves' do
    expect(subject.next_move(double)).to eq 1
    expect(subject.next_move(double)).to eq 2
    expect(subject.next_move(double)).to eq 3
  end
end
