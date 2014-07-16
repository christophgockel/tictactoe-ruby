require 'spec_helper'

require 'human_player'

describe HumanPlayer do
  it_should_behave_like 'a player'

  let(:input) { StringIO.new }
  subject { described_class.new('h', input) }

  it 'gets its next move from stdin' do
    input.string = "42\n"

    move = subject.next_move(double)

    expect(move).to eq 42
  end
end
