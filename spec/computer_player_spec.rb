require 'timeout'
require 'spec_helper'

require 'computer_player'

RSpec.describe ComputerPlayer do
  subject { described_class.new('o', 'x') }

  it_should_behave_like 'a player'

  RSpec::Matchers.alias_matcher :result_in, :eq

  let(:x) { 'x' }
  let(:o) { 'o' }

  it 'blocks possible wins for every row' do
    expect(next_move_for(x).in(' oo      '))
                 .to result_in('xoo      ')

    expect(next_move_for(x).in('o o      '))
                 .to result_in('oxo      ')

    expect(next_move_for(x).in('oo       '))
                 .to result_in('oox      ')

    expect(next_move_for(x).in('    oo   '))
                 .to result_in('   xoo   ')

    expect(next_move_for(x).in('   o o   '))
                 .to result_in('   oxo   ')

    expect(next_move_for(x).in('   oo    '))
                 .to result_in('   oox   ')

    expect(next_move_for(x).in('       oo'))
                 .to result_in('      xoo')

    expect(next_move_for(x).in('      o o'))
                 .to result_in('      oxo')

    expect(next_move_for(x).in('      oo '))
                 .to result_in('      oox')
  end

  it 'blocks possible wins for every column' do
    expect(next_move_for(o).in('   x  x  '))
                 .to result_in('o  x  x  ')

    expect(next_move_for(o).in('x     x  '))
                 .to result_in('x  o  x  ')

    expect(next_move_for(o).in('x  x     '))
                 .to result_in('x  x  o  ')

    expect(next_move_for(o).in('    x  x '))
                 .to result_in(' o  x  x ')

    expect(next_move_for(o).in(' x     x '))
                 .to result_in(' x  o  x ')

    expect(next_move_for(o).in(' x  x    '))
                 .to result_in(' x  x  o ')

    expect(next_move_for(o).in('     x  x'))
                 .to result_in('  o  x  x')

    expect(next_move_for(o).in('  x     x'))
                 .to result_in('  x  o  x')

    expect(next_move_for(o).in('  x  x   '))
                 .to result_in('  x  x  o')
  end

  it 'blocks possible wins for every diagonale' do
    expect(next_move_for(o).in('    x   x'))
                 .to result_in('o   x   x')

    expect(next_move_for(o).in('x       x'))
                 .to result_in('x   o   x')

    expect(next_move_for(o).in('x   x    '))
                 .to result_in('x   x   o')

    expect(next_move_for(x).in('    o o  '))
                 .to result_in('  x o o  ')

    expect(next_move_for(x).in('  o   o  '))
                 .to result_in('  o x o  ')

    expect(next_move_for(x).in('  o o    '))
                 .to result_in('  o o x  ')
  end

  it 'wins when possible' do
    expect(next_move_for(x).in(' xx      '))
                 .to result_in('xxx      ')

    expect(next_move_for(x).in('x x      '))
                 .to result_in('xxx      ')

    expect(next_move_for(x).in('xx       '))
                 .to result_in('xxx      ')

    expect(next_move_for(x).in('    xx   '))
                 .to result_in('   xxx   ')

    expect(next_move_for(x).in('   x x   '))
                 .to result_in('   xxx   ')

    expect(next_move_for(x).in('   xx    '))
                 .to result_in('   xxx   ')

    expect(next_move_for(x).in('       xx'))
                 .to result_in('      xxx')

    expect(next_move_for(x).in('      x x'))
                 .to result_in('      xxx')

    expect(next_move_for(x).in('      xx '))
                 .to result_in('      xxx')

    expect(next_move_for(x).in('   x  x  '))
                 .to result_in('x  x  x  ')

    expect(next_move_for(x).in('x     x  '))
                 .to result_in('x  x  x  ')

    expect(next_move_for(x).in('x  x     '))
                 .to result_in('x  x  x  ')

    expect(next_move_for(x).in('    x  x '))
                 .to result_in(' x  x  x ')

    expect(next_move_for(x).in(' x     x '))
                 .to result_in(' x  x  x ')

    expect(next_move_for(x).in(' x  x    '))
                 .to result_in(' x  x  x ')

    expect(next_move_for(x).in('     x  x'))
                 .to result_in('  x  x  x')

    expect(next_move_for(x).in('  x     x'))
                 .to result_in('  x  x  x')

    expect(next_move_for(x).in('  x  x   '))
                 .to result_in('  x  x  x')

    expect(next_move_for(x).in('    x   x'))
                 .to result_in('x   x   x')

    expect(next_move_for(x).in('x       x'))
                 .to result_in('x   x   x')

    expect(next_move_for(x).in('x   x    '))
                 .to result_in('x   x   x')

    expect(next_move_for(o).in('    o o  '))
                 .to result_in('  o o o  ')

    expect(next_move_for(o).in('  o   o  '))
                 .to result_in('  o o o  ')

    expect(next_move_for(o).in('  o o    '))
                 .to result_in('  o o o  ')
  end

  it 'blocks moves in real game constellations' do
    expect(next_move_for(o).in('ox xxo   '))
                 .to result_in('ox xxo o ')

    expect(next_move_for(o).in('  ooxx  x'))
                 .to result_in('o ooxx  x')
  end

  context '4x4 boards' do
    it 'handles 4x4 boards' do
      board = board_with('x o x o  ooox   ', 4)
      computer = ComputerPlayer.new('o', 'x')

      expect(computer.next_move(board)).to eq 9
    end

    it 'takes < 3 seconds for its initial move' do
      Timeout::timeout(3) do
        board = board_with('                ', 4)
        computer = ComputerPlayer.new('o', 'x')

        computer.next_move(board)
      end
    end

    it 'should block a possible win' do
      board = board_with('oxoo     x  xxxo', 4)
      computer = ComputerPlayer.new('o', 'x')

      expect(computer.next_move(board)).to eq 6
    end
  end

  def next_move_for(mark)
    BoardHelper::Builder.new(ComputerPlayer.new(mark, mark == x ? o : x))
  end
end
