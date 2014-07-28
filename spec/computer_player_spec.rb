require 'timeout'
require 'spec_helper'

require 'computer_player'

RSpec.describe ComputerPlayer do
  subject { described_class.new('o', 'x') }

  it_should_behave_like 'a player'

  RSpec::Matchers.alias_matcher :result_in, :eq

  let(:x) { 'x' }
  let(:o) { 'o' }

  [
    { initial:  ' oo      ',
      expected: 'xoo      '},

    { initial:  'o o      ',
      expected: 'oxo      '},

    { initial:  'oo       ',
      expected: 'oox      '},

    { initial:  '    oo   ',
      expected: '   xoo   '},

    { initial:  '   o o   ',
      expected: '   oxo   '},

    { initial:  '   oo    ',
      expected: '   oox   '},

    { initial:  '       oo',
      expected: '      xoo'},

    { initial:  '      o o',
      expected: '      oxo'},

    { initial:  '      oo ',
      expected: '      oox'},
  ].each do |boards|
    it "blocks wins in row for '#{boards[:initial]}'" do
      expect(next_move_for(x).in(boards[:initial]))
                   .to result_in(boards[:expected])
    end
  end

  [
    { initial:  '   x  x  ',
      expected: 'o  x  x  '},

    { initial:  'x     x  ',
      expected: 'x  o  x  '},

    { initial:  'x  x     ',
      expected: 'x  x  o  '},

    { initial:  '    x  x ',
      expected: ' o  x  x '},

    { initial:  ' x     x ',
      expected: ' x  o  x '},

    { initial:  ' x  x    ',
      expected: ' x  x  o '},

    { initial:  '     x  x',
      expected: '  o  x  x'},

    { initial:  '  x     x',
      expected: '  x  o  x'},

    { initial:  '  x  x   ',
      expected: '  x  x  o'},
  ].each do |boards|
    it "blocks wins in column for '#{boards[:initial]}'" do
      expect(next_move_for(o).in(boards[:initial]))
                   .to result_in(boards[:expected])
    end
  end

  [
    { initial:  '    x   x',
      expected: 'o   x   x'},

    { initial:  'x       x',
      expected: 'x   o   x'},

    { initial:  'x   x    ',
      expected: 'x   x   o'},

    { initial:  '    x x  ',
      expected: '  o x x  '},

    { initial:  '  x   x  ',
      expected: '  x o x  '},

    { initial:  '  x x    ',
      expected: '  x x o  '},
  ].each do |boards|
    it "blocks wins in diagonale '#{boards[:initial]}'" do
      expect(next_move_for(o).in(boards[:initial]))
                   .to result_in(boards[:expected])
    end
  end

  [
    { initial:  ' xx      ',
      expected: 'xxx      '},

    { initial:  'x x      ',
      expected: 'xxx      '},

    { initial:  'xx       ',
      expected: 'xxx      '},

    { initial:  '    xx   ',
      expected: '   xxx   '},

    { initial:  '   x x   ',
      expected: '   xxx   '},

    { initial:  '   xx    ',
      expected: '   xxx   '},

    { initial:  '       xx',
      expected: '      xxx'},

    { initial:  '      x x',
      expected: '      xxx'},

    { initial:  '      xx ',
      expected: '      xxx'},

    { initial:  '   x  x  ',
      expected: 'x  x  x  '},

    { initial:  'x     x  ',
      expected: 'x  x  x  '},

    { initial:  'x  x     ',
      expected: 'x  x  x  '},

    { initial:  '    x  x ',
      expected: ' x  x  x '},

    { initial:  ' x     x ',
      expected: ' x  x  x '},

    { initial:  ' x  x    ',
      expected: ' x  x  x '},

    { initial:  '     x  x',
      expected: '  x  x  x'},

    { initial:  '  x     x',
      expected: '  x  x  x'},

    { initial:  '  x  x   ',
      expected: '  x  x  x'},

    { initial:  '    x   x',
      expected: 'x   x   x'},

    { initial:  'x       x',
      expected: 'x   x   x'},

    { initial:  'x   x    ',
      expected: 'x   x   x'},

    { initial:  '    x x  ',
      expected: '  x x x  '},

    { initial:  '  x   x  ',
      expected: '  x x x  '},

    { initial:  '  x x    ',
      expected: '  x x x  '},
  ].each do |boards|
    it "wins when possible '#{boards[:initial]}'" do
      expect(next_move_for(x).in(boards[:initial]))
      .to result_in(boards[:expected])
    end
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
