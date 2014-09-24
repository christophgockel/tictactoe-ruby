#require 'tictactoe-ui/spec_helper'

require 'tictactoe-ui/commandline_ui'
require 'tictactoe-ui/commandline_io'

describe TicTacToeUI::CommandlineUI do
  let(:output)  { StringIO.new }
  let(:input)   { StringIO.new }
  let(:display) { TicTacToeUI::CommandlineIO.new(input, output) }
  let(:ui)      { described_class.new(display) }
  let(:modes)   { [:a, :b, :c] }
  let(:sizes)   { [:_1x1, :_2x2] }

  context 'setting up a game' do
    before :each do
      input.string = "1\n"
    end

    it 'asks the display to show a list of available board sizes' do
      expect(display).to receive(:show_board_sizes).with(sizes)

      ui = described_class.new(display)
      ui.ask_for_board_size(sizes)
    end

    it 'accepts input after showing the list of available board sizes' do
      expect(display).to receive(:prompt_for_choice).and_call_original

      ui = described_class.new(display)
      ui.ask_for_board_size(modes)
    end

    it 'keeps asking for input until valid choice has been made' do
      input.string = "wrong\ninput\n9\n1"
      expect(display).to receive(:prompt_for_choice).exactly(4).times.and_call_original

      ui = described_class.new(display)
      ui.ask_for_board_size(sizes)
    end

    it 'asks the display to show a list of available game modes' do
      expect(display).to receive(:show_game_modes).with(modes)

      ui = described_class.new(display)
      ui.ask_for_game_mode(modes)
    end

    it 'accepts input after showing the list of available game modes' do
      expect(display).to receive(:prompt_for_choice).and_call_original

      ui = described_class.new(display)
      ui.ask_for_game_mode(modes)
    end

    it 'keeps asking for input until valid choice has been made' do
      input.string = "wrong\ninput\n9\n1"
      expect(display).to receive(:prompt_for_choice).exactly(4).times.and_call_original

      ui = described_class.new(display)
      ui.ask_for_game_mode(modes)
    end
  end

  context 'playing a game' do
    let(:game) { double("Game", :is_ongoing? => false, :play_next_round => nil) }

    it 'plays a game until its done' do
      allow(game).to receive(:is_ongoing?).and_return(true, false)
      ui.play(game)

      expect(game).to have_received(:is_ongoing?).exactly(2).times
    end

    it 'plays rounds consecutively' do
      allow(game).to receive(:is_ongoing?).and_return(true, true, false)
      ui.play(game)

      expect(game).to have_received(:play_next_round).exactly(2).times
    end
  end
end
