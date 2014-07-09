require 'spec_helper'

require 'board'

describe Board do
  it 'is empty when just created' do
    board = Board.new
    expect(board.empty?).to be true
  end

  it 'is not empty when it got a move placed' do
    board = Board.new
    board.set(some_move)

    expect(board.empty?).to be false
  end

  it 'can return its rows' do
    board = board_with('111222333')
    
    expect(board.rows).to eq [['1', '1', '1'], ['2', '2', '2'], ['3', '3', '3']]
  end

  it 'can return its columns' do
    board = board_with('123123123')
    expect(board.columns).to eq [['1', '1', '1'], ['2', '2', '2'], ['3', '3', '3']]
  end

  it 'can return its diagonals' do
    board = board_with('123456789')
    expect(board.diagonals).to eq [['1', '5', '9'], ['3', '5', '7']]
  end

  it 'knows free spots' do
    expect(board_with('x oxxo  x').free_spots).to eq [1, 6, 7]
  end

  it 'moves can be undone' do
    board = Board.new
    board.set(Move.new('x', 3))
    board.undo(3)

    expect(board.empty?).to be true
  end

  it 'knows how many moves were made' do
    board = Board.new
    board.set(some_move)

    expect(board.moves_made).to eq(1)
  end

  it 'knows when it is full' do
    expect(full_board.is_full?).to eq true
  end

  def some_move
    Move.new('x', 0)
  end

  def full_board
    board_with('ooxxxooxo')
  end

  context 'Move constellations' do
    let(:board) { Board.new }

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
    end

    it 'knows the winner' do
      expect(board_with('xxx      ').winner).to eq 'x'
      expect(board_with('ooo      ').winner).to eq 'o'
      expect(board_with('   xxx   ').winner).to eq 'x'
      expect(board_with('      ooo').winner).to eq 'o'
      expect(board_with('x  x  x  ').winner).to eq 'x'
      expect(board_with(' o  o  o ').winner).to eq 'o'
      expect(board_with('  x  x  x').winner).to eq 'x'
      expect(board_with('o   o   o').winner).to eq 'o'
      expect(board_with('  x x x  ').winner).to eq 'x'
    end

    it 'returns nil when no one is the winner' do
      expect(board_with('xox      ').winner).to be_nil
    end

    it 'knows when there is no winner' do
      expect(board_with('xox      ').has_winner?).to eq false
      expect(board_with('oxoxoxxox').has_winner?).to eq false
    end

    it 'knows when it is completed' do
      board = board_with('ooxxxooxo')

      expect(board.is_done?).to eq true
      expect(board.has_winner?).to eq false
    end
  end
end
