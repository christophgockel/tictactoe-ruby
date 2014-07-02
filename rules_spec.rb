require 'rspec'

require 'rules'
require 'player'
require 'spec_helper'

describe Rules do
  let(:rules) { Rules.new }

  it 'knows when a board has a winning row' do
    expect(rules.has_winner?(board_with('xxx      '))).to eq true
    expect(rules.has_winner?(board_with('   xxx   '))).to eq true
    expect(rules.has_winner?(board_with('      xxx'))).to eq true
  end

  it 'knows a winning state for every player' do
    expect(rules.has_winner?(board_with('xxx      '))).to eq true
    expect(rules.has_winner?(board_with('      ooo'))).to eq true
  end

  it 'knows when a board has a winning column' do
    expect(rules.has_winner?(board_with('x  x  x  '))).to eq true
    expect(rules.has_winner?(board_with(' x  x  x '))).to eq true
    expect(rules.has_winner?(board_with('  x  x  x'))).to eq true
  end

  it 'knows when a board has a winning diagonal' do
    expect(rules.has_winner?(board_with('x   x   x'))).to eq true
  end

  it 'knows the winner' do
    expect(rules.winner(board_with('xxx      '))).to eq Player::X
    expect(rules.winner(board_with('ooo      '))).to eq Player::O
    expect(rules.winner(board_with('   xxx   '))).to eq Player::X
    expect(rules.winner(board_with('      ooo'))).to eq Player::O
    expect(rules.winner(board_with('x  x  x  '))).to eq Player::X
    expect(rules.winner(board_with(' o  o  o '))).to eq Player::O
    expect(rules.winner(board_with('  x  x  x'))).to eq Player::X
    expect(rules.winner(board_with('o   o   o'))).to eq Player::O
    expect(rules.winner(board_with('  x x x  '))).to eq Player::X
  end

  it 'returns nil when no one is the winner' do
    expect(rules.winner(board_with('xox      '))).to be_nil
  end

  it 'knows when there is no winner' do
    expect(rules.has_winner?(board_with('xox      '))).to eq false
    expect(rules.has_winner?(board_with('oxoxoxxox'))).to eq false
  end
end
