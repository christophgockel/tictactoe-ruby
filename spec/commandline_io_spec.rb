require "spec_helper"
require "commandline_io"

describe CommandlineIO do
  subject { display }
  it_should_behave_like 'a game io object'

  let(:input)   { StringIO.new }
  let(:output)  { StringIO.new }
  let(:display) { CommandlineIO.new(input, output) }

  context 'board contents' do
    it 'shows indexes on empty spots in board' do
      display.show_board(board_with('         '))

      expect(output.string).to include('1 | 2 | 3')
      expect(output.string).to include('4 | 5 | 6')
      expect(output.string).to include('7 | 8 | 9')
    end

    it 'shows the board content on its output' do
      display.show_board(board_with('abcdefghi'))

      expect(output.string).to include('a | b | c')
      expect(output.string).to include('d | e | f')
      expect(output.string).to include('g | h | i')
    end

    context '4x4 boards' do
      it 'displays initial 4x4 boards properly aligned' do
        display.show_board(board_with('                ', 4))

        expect(output.string).to include('1  |  2  |  3  |  4')
        expect(output.string).to include('5  |  6  |  7  |  8')
        expect(output.string).to include('9  |  10 |  11 |  12')
        expect(output.string).to include('13 |  14 |  15 |  16')
      end

      it 'displays 4x4 boards' do
        display.show_board(board_with('abcdefghijklmnop', 4))

        expect(output.string).to include('a  |  b  |  c  |  d')
        expect(output.string).to include('e  |  f  |  g  |  h')
        expect(output.string).to include('i  |  j  |  k  |  l')
        expect(output.string).to include('m  |  n  |  o  |  p')
      end

      it 'displays 4x4 boards with content' do
        display.show_board(board_with(' x         o    ', 4))

        expect(output.string).to include('1  |  x  |  3  |  4')
        expect(output.string).to include('5  |  6  |  7  |  8')
        expect(output.string).to include('9  |  10 |  11 |  o ')
        expect(output.string).to include('13 |  14 |  15 |  16')
      end
    end
  end

  context 'invalid moves' do
    it 'shows a message' do
      display.show_invalid_move_message

      expect(output.string).to include('Invalid move')
    end
  end

  context 'next moves' do
    it 'provides the next move from stdin' do
      input.string = "42\n"
      expect(display.next_move).to eq 42
    end

    it 'is always ready to provide a new move' do
      expect(display.can_provide_next_move?).to eq true
    end
  end

  context 'announcing next player' do
    it 'shows the mark of the next player' do
      display.announce_next_player('a')
      expect(output.string).to include 'Next move for a:'
    end
  end

  context 'announcing the winner' do
    it 'shows the winner' do
      display.announce_winner('b')
      expect(output.string).to include "Winner is: b"
    end
  end

  context 'announcing a draw' do
    it 'shows a message that the game ended in draw' do
      display.announce_draw
      expect(output.string).to include 'Game ended in a draw.'
    end
  end

  context 'game mode selection' do
    it 'presents a list of available game types' do
      display.show_game_modes([
        :human_computer,
        :human_human,
        :computer_human,
        :computer_computer
      ])

      expect(output.string).to include 'Available game modes'
      expect(output.string).to include '(1) Human vs. Computer'
      expect(output.string).to include '(2) Human vs. Human'
      expect(output.string).to include '(3) Computer vs. Human'
      expect(output.string).to include '(4) Computer vs. Computer'
    end
  end

  context 'option selection' do
    it 'asks for a choice' do
      allow(input).to receive(:gets).and_return("2")
      expect(output).to receive(:puts).with("Your choice: ")
      choice = display.prompt_for_choice

      expect(choice).to eq(2)
    end
  end

  context 'board size selection' do
    it 'presents a list of available board sizes' do
      display.show_board_sizes([
        :board_3x3,
        :board_4x4
      ])

      expect(output.string).to include 'Available board sizes'
      expect(output.string).to include '(1) 3x3'
      expect(output.string).to include '(2) 4x4'
    end
  end
end
