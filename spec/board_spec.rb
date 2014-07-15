require 'spec_helper'

require 'board'

describe Board do
  let(:board) { Board.new }

  it 'is empty when just created' do
    expect(board.empty?).to be true
  end

  it 'is not empty when it got a move placed' do
    board.set_move(1, 'o')

    expect(board.empty?).to be false
  end

  it 'knows how many moves were made' do
    board.set_move(2, 'x')

    expect(board.moves_made).to eq(1)
  end

  it 'moves can be undone' do
    board.set_move(3, 'x')
    board.unset_move(3)

    expect(board.empty?).to be true
  end

  it 'locations can not be set more than once' do
    board = board_with('x        ')
    expect { board.set_move(0, 'o') }.to raise_error(Board::IllegalMove)
  end

  it 'only accepts numbers as locations' do
    board = board_with('         ')
    expect { board.set_move('1', 'o') }.to raise_error(Board::IllegalMove)
  end

  it 'knows free locations' do
    expect(board_with('x oxxo  x').free_locations).to eq [1, 6, 7]
  end

  it 'provides its rows' do
    expect(board_with('123456789').rows).to eq [['1', '2', '3'],
                                                ['4', '5', '6'],
                                                ['7', '8', '9']]
  end

  it 'knows when it is full' do
    expect(board_with('ooxxxooxo').is_full?).to eq true
  end

  context 'Move constellations' do
    it 'knows when there is a winning row' do
      expect(board_with('xxx      ').has_winner?).to eq true
      expect(board_with('   xxx   ').has_winner?).to eq true
      expect(board_with('      xxx').has_winner?).to eq true
    end

    it 'knows a winning state for every player' do
      expect(board_with('xxx      ').has_winner?).to eq true
      expect(board_with('      ooo').has_winner?).to eq true
    end

    it 'knows when a board has a winning column' do
      expect(board_with('x  x  x  ').has_winner?).to eq true
      expect(board_with(' x  x  x ').has_winner?).to eq true
      expect(board_with('  x  x  x').has_winner?).to eq true
    end

    it 'knows when a board has a winning diagonal' do
      expect(board_with('x   x   x').has_winner?).to eq true
      expect(board_with('  o o o  ').has_winner?).to eq true
    end

    it 'knows the winner' do
      expect(board_with('xxx      ').winner?('x')).to be true
      expect(board_with('ooo      ').winner?('x')).to be false
      expect(board_with('   xxx   ').winner?('x')).to be true
      expect(board_with('      ooo').winner?('x')).to be false
      expect(board_with('x  x  x  ').winner?('x')).to be true
      expect(board_with(' o  o  o ').winner?('o')).to be true
      expect(board_with('  x  x  x').winner?('x')).to be true
      expect(board_with('o   o   o').winner?('o')).to be true
      expect(board_with('  x x x  ').winner?('o')).to be false
    end

    it 'knows when it is completed' do
      expect(board_with('ooxxxooxo').is_completed?).to eq true
      expect(board_with('         ').is_completed?).to eq false
    end
  end
end
