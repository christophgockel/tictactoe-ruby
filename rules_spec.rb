require 'rspec'

require 'rules'
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
end
