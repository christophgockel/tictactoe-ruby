require 'spec_helper'

require 'human_player'

describe HumanPlayer do
  it_should_behave_like 'a player'

  let(:input) { double("Player IO", :next_move => 42, :can_provide_next_move? => true) }
  subject { described_class.new('h', input) }

  it 'gets its next move from an input object' do
    move = subject.next_move(double)

    expect(move).to eq 42
  end

  it 'asks its input object if it can provide a new move' do
    subject.ready?
    expect(input).to have_received(:can_provide_next_move?)
  end
end
