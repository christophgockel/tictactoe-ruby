require 'rspec'

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


  def some_move
    Move.new('x', 0)
  end
end
