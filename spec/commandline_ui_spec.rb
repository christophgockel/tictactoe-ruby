require 'spec_helper'

require 'commandline_ui'
require 'game'

describe CommandlineUI do
  it 'displays the board when started' do
    output = StringIO.new
    a = FakePlayer.new('a', 1)
    b = FakePlayer.new('b', 2)
    game = Game.init(a, b, board_with(' bcdefghi'))
    ui = CommandlineUI.new(game, output)

    ui.run

    expect(output.string).to include('1 | b | c')
    expect(output.string).to include('d | e | f')
    expect(output.string).to include('g | h | i')
  end

  it 'prints a message when asking for next player\'s move' do
    output = StringIO.new
    a = FakePlayer.new('a', 1)
    b = FakePlayer.new('b', 2)
    game = Game.init(a, b, board_with(' bcdefghi'))
    ui = CommandlineUI.new(game, output)

    ui.run

    expect(output.string).to include 'Next move:'
  end

  it 'prints the winner at the end' do
    output = StringIO.new
    a = FakePlayer.new('a', 2)
    b = FakePlayer.new('b', 2)
    game = Game.init(a, b, board_with('a aabbbba'))
    ui = CommandlineUI.new(game, output)

    ui.run

    expect(output.string.include?('Winner is: a')).to eq true
  end

  it 'plays the game until there is a winner' do
    output = StringIO.new
    a = FakePlayer.new('a', 9)
    b = FakePlayer.new('b', 3)
    game = Game.init(a, b, board_with('bb aa    '))
    ui = CommandlineUI.new(game, output)

    ui.run

    expect(output.string.include?('Winner is: b')).to eq true
  end
end

class FakePlayer
  attr_reader :mark

  def initialize(mark, *next_moves)
    @mark = mark
    @next_moves = next_moves
  end

  def next_move(board)
    @next_moves.pop
  end
end
