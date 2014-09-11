require 'spec_helper'

require 'gui/gui_player'

describe GuiPlayer do
  it_should_behave_like 'a player'

  subject { described_class.new('g') }

  it 'can have its next move prepared in advance' do
    subject.next_move_to_play = 42

    expect(subject.next_move(double)).to eq 42
  end
end
