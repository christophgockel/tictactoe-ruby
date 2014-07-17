require 'simplecov'

SimpleCov.start do
    add_filter '/spec/'
end

require 'board'

def board_with(contents)
  board = Board.new

  contents.split('').each_with_index do |symbol, index|
    board.set_move(index + 1, (symbol == ' ' ? nil : symbol))
  end

  board
end

shared_context 'a player' do
  it 'has a mark' do
    expect(subject).to respond_to(:mark)
  end

  it 'can provide the next move' do
    expect(subject).to respond_to(:next_move).with(1).arguments
  end
end
