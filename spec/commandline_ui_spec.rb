require 'spec_helper'

require 'commandline_ui'
require 'game'
require 'fake_player'

describe CommandlineUI do
  let(:output) { StringIO.new }

  it 'displays the board when started' do
    a = FakePlayer.new('a', 1)
    b = FakePlayer.new('b', 2)
    game = Game.new(a, b, board_with(' bcdefghi'))
    ui = CommandlineUI.new(game, output)

    ui.run

    expect(output.string).to include('1 | b | c')
    expect(output.string).to include('d | e | f')
    expect(output.string).to include('g | h | i')
  end

  it 'prints a message when asking for next player\'s move' do
    a = FakePlayer.new('a', 1)
    b = FakePlayer.new('b', 2)
    game = Game.new(a, b, board_with(' bcdefghi'))
    ui = CommandlineUI.new(game, output)

    ui.run

    expect(output.string).to include 'Next move:'
  end

  it 'prints the winner at the end' do
    a = FakePlayer.new('a', 2)
    b = FakePlayer.new('b', 2)
    game = Game.new(a, b, board_with('a aabbbba'))
    ui = CommandlineUI.new(game, output)

    ui.run

    expect(output.string.include?('Winner is: a')).to eq true
  end

  it 'plays the game until there is a winner' do
    a = FakePlayer.new('a', 9)
    b = FakePlayer.new('b', 3)
    game = Game.new(a, b, board_with('bb aa    '))
    ui = CommandlineUI.new(game, output)

    ui.run

    expect(output.string.include?('Winner is: b')).to eq true
  end

  it 'notifies about a draw' do
    a = FakePlayer.new('a', 9)
    b = FakePlayer.new('b', 3)
    game = Game.new(a, b, board_with('bbaaabbba'))
    ui = CommandlineUI.new(game, output)

    ui.run

    expect(output.string).to include 'Game ended in a draw.'
  end

  it 'prints an error message on invalid moves' do
    a = FakePlayer.new('a', 1)
    b = FakePlayer.new('b', 2, 3)
    game = Game.new(a, b, board_with(' b bababb'))
    ui = CommandlineUI.new(game, output)

    ui.run

    expect(output.string).to include 'Invalid move!'
  end
end
