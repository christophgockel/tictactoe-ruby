require 'spec_helper'

require 'commandline_ui'
require 'game'
require 'fake_player'

describe CommandlineUI do
  let(:output) { StringIO.new }
  let(:input) { StringIO.new }

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

  context 'initial game setup' do
    it 'asks for game type at the beginning when no game is passed' do
      ui = CommandlineUI.new(nil, output, StringIO.new("1\n"))
      ui.ask_for_game_type

      expect(output.string).to include 'Available game types'
      expect(output.string).to include '(1) Human vs. Computer'
      expect(output.string).to include '(2) Human vs. Human'
      expect(output.string).to include '(3) Computer vs. Human'
      expect(output.string).to include '(4) Computer vs. Computer'
    end

    it 'maps input values to game types' do
      ui = CommandlineUI.new(nil, output, StringIO.new("1\n2\n3\n4\n"))
      expect(ui.get_game_type).to eq :human_vs_computer
      expect(ui.get_game_type).to eq :human_vs_human
      expect(ui.get_game_type).to eq :computer_vs_human
      expect(ui.get_game_type).to eq :computer_vs_computer
    end

    it 'prints an error message on invalid game type choice' do
      ui = CommandlineUI.new(nil, output, StringIO.new("some invalid input\n2\n"))

      ui.prompt_for_game_type
      expect(output.string).to include 'Invalid choice'
    end

    it 'keeps asking for game type until valid input' do
      ui = CommandlineUI.new(nil, output, StringIO.new("invalid input\n2\n"))
      expect(ui.prompt_for_game_type).to eq 2
    end
  end

  context '4x4 boards' do
    it 'displays initial 4x4 boards properly aligned' do
      a = FakePlayer.new('a', 1)
      b = FakePlayer.new('b', 2)
      board = board_with('                ', 4)
      game = Game.new(a, b, board)
      ui = CommandlineUI.new(game, output)

      ui.display_board(board)

      expect(output.string).to include('1  |  2  |  3  |  4')
      expect(output.string).to include('5  |  6  |  7  |  8')
      expect(output.string).to include('9  |  10 |  11 |  12')
      expect(output.string).to include('13 |  14 |  15 |  16')
    end

    it 'displays 4x4 boards' do
      a = FakePlayer.new('a', 1)
      b = FakePlayer.new('b', 2)
      board = board_with('abcdefghijklmnop', 4)
      game = Game.new(a, b, board)
      ui = CommandlineUI.new(game, output)

      ui.display_board(board)

      expect(output.string).to include('a  |  b  |  c  |  d')
      expect(output.string).to include('e  |  f  |  g  |  h')
      expect(output.string).to include('i  |  j  |  k  |  l')
      expect(output.string).to include('m  |  n  |  o  |  p')
    end

    it 'displays 4x4 boards with content' do
      a = FakePlayer.new('a', 1)
      b = FakePlayer.new('b', 2)
      board = board_with(' x         o    ', 4)
      game = Game.new(a, b, board)
      ui = CommandlineUI.new(game, output)

      ui.display_board(board)

      expect(output.string).to include('1  |  x  |  3  |  4')
      expect(output.string).to include('5  |  6  |  7  |  8')
      expect(output.string).to include('9  |  10 |  11 |  o ')
      expect(output.string).to include('13 |  14 |  15 |  16')
    end
  end

  it 'can colorize output' do
    a = FakePlayer.new('a', 1)
    b = FakePlayer.new('b', 2)
    board = board_with('         ')
    game = Game.new(a, b, board)
    ui = CommandlineUI.new(game, output)

    ui.use_colors
    ui.display_board(board)

    expect(output.string).to include "\e[0;90;49m1\e[0m | \e[0;90;49m2\e[0m | \e[0;90;49m3\e[0m"
  end
end
