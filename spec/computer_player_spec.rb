require 'spec_helper'

require 'computer_player'

describe ComputerPlayer do
  subject { described_class.new('o') }

  it_should_behave_like 'a player'

  let(:opponent) { ComputerPlayer.new('o') }
  let(:x) { 'x' }
  let(:o) { 'o' }

  it 'blocks possible wins for every row' do
    expect(next_move_for(x).in(' oo      ')).to eq 1
    expect(next_move_for(x).in('o o      ')).to eq 2
    expect(next_move_for(x).in('oo       ')).to eq 3

    expect(next_move_for(x).in('    oo   ')).to eq 4
    expect(next_move_for(x).in('   o o   ')).to eq 5
    expect(next_move_for(x).in('   oo    ')).to eq 6

    expect(next_move_for(x).in('       oo')).to eq 7
    expect(next_move_for(x).in('      o o')).to eq 8
    expect(next_move_for(x).in('      oo ')).to eq 9
  end

  it 'blocks possible wins for every column' do
    expect(next_move_for(o).in('   x  x  ')).to eq 1
    expect(next_move_for(o).in('x     x  ')).to eq 4
    expect(next_move_for(o).in('x  x     ')).to eq 7

    expect(next_move_for(o).in('    x  x ')).to eq 2
    expect(next_move_for(o).in(' x     x ')).to eq 5
    expect(next_move_for(o).in(' x  x    ')).to eq 8

    expect(next_move_for(o).in('     x  x')).to eq 3
    expect(next_move_for(o).in('  x     x')).to eq 6
    expect(next_move_for(o).in('  x  x   ')).to eq 9
  end

  it 'blocks possible wins for every diagonale' do
    expect(next_move_for(o).in('    x   x')).to eq 1
    expect(next_move_for(o).in('x       x')).to eq 5
    expect(next_move_for(o).in('x   x    ')).to eq 9

    expect(next_move_for(x).in('    o o  ')).to eq 3
    expect(next_move_for(x).in('  o   o  ')).to eq 5
    expect(next_move_for(x).in('  o o    ')).to eq 7
  end

  it 'wins when possible' do
    expect(next_move_for(x).in(' xx      ')).to eq 1
    expect(next_move_for(x).in('x x      ')).to eq 2
    expect(next_move_for(x).in('xx       ')).to eq 3

    expect(next_move_for(x).in('    xx   ')).to eq 4
    expect(next_move_for(x).in('   x x   ')).to eq 5
    expect(next_move_for(x).in('   xx    ')).to eq 6

    expect(next_move_for(x).in('       xx')).to eq 7
    expect(next_move_for(x).in('      x x')).to eq 8
    expect(next_move_for(x).in('      xx ')).to eq 9

    expect(next_move_for(x).in('   x  x  ')).to eq 1
    expect(next_move_for(x).in('x     x  ')).to eq 4
    expect(next_move_for(x).in('x  x     ')).to eq 7

    expect(next_move_for(x).in('    x  x ')).to eq 2
    expect(next_move_for(x).in(' x     x ')).to eq 5
    expect(next_move_for(x).in(' x  x    ')).to eq 8

    expect(next_move_for(x).in('     x  x')).to eq 3
    expect(next_move_for(x).in('  x     x')).to eq 6
    expect(next_move_for(x).in('  x  x   ')).to eq 9

    expect(next_move_for(x).in('    x   x')).to eq 1
    expect(next_move_for(x).in('x       x')).to eq 5
    expect(next_move_for(x).in('x   x    ')).to eq 9

    expect(next_move_for(o).in('    o o  ')).to eq 3
    expect(next_move_for(o).in('  o   o  ')).to eq 5
    expect(next_move_for(o).in('  o o    ')).to eq 7
  end

  it 'blocks moves in real game constellations' do
    expect(next_move_for(o).in('ox xxo   ')). to eq 8
    expect(next_move_for(o).in('  ooxx  x')). to eq 1
  end

  class BoardHelper
    def initialize(player, opponent)
      @player = player
      @opponent = opponent
    end

    def in(board_state)
      @opponent.next_move(board_with(board_state))
    end
  end

  def next_move_for(player)
    BoardHelper.new(player, opponent)
  end
end
