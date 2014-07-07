require 'opponent'

describe Opponent do
  let(:opponent) { Opponent.new }
  let(:x) { Player::X }

  it 'blocks possible wins for every row' do
    expect(next_move_for(x).in(' oo      ')).to eq 0
    expect(next_move_for(x).in('o o      ')).to eq 1
    expect(next_move_for(x).in('oo       ')).to eq 2
    expect(next_move_for(x).in('    oo   ')).to eq 3
    expect(next_move_for(x).in('   o o   ')).to eq 4
    expect(next_move_for(x).in('   oo    ')).to eq 5
    expect(next_move_for(x).in('       oo')).to eq 6
    expect(next_move_for(x).in('      o o')).to eq 7
    expect(next_move_for(x).in('      oo ')).to eq 8
  end


  class BoardHelper
    def initialize(player, opponent)
      @player = player
      @opponent = opponent
    end

    def in(board_state)
      @opponent.next_move(@player, board_with(board_state))
    end
  end

  def next_move_for(player)
    BoardHelper.new(player, opponent)
  end
end
